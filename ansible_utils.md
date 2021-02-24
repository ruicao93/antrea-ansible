## Run ansible-playbook

``` shell
ansible-playbook -vvvvv -i hosts tasks.yml
```

## Check file exists

``` yml
tasks:
  - name: Check that the somefile.conf exists
    stat:
      path: /etc/file.txt
    register: stat_result
   - name: Create the file, if it doesnt exist already
    file:
      path: /etc/file.txt
      state: touch
    when: not stat_result.stat.exists
```

## Download file

``` yml
- name: OVS | Download certificate beta
  win_get_url:
    url: "{{ovs_certs_link}}"
    dest: "{{ovs_info.tmp_dir}}\\certificate.cer"
    timeout: 60
  retries: 3
  when: ovs_certs_link is defined
```

## Priviledge

``` yml
- name: Install NSX-OVS
  become: yes
  become_method: runas
  become_user: SYSTEM
  win_shell: |
    $ErrorActionPreference = "Stop"
    cd {{antrea_ansible_path}}
    ./Install-OVS.ps1 -LocalFile ovs-win64.zip
  register: nsxovs_install_result
  when: ovs_type is defined and ovs_type|lower == "nsx"
```

## Refs:

- [User guide](https://docs.ansible.com/ansible/latest/user_guide/index.html#writing-tasks-plays-and-playbooks)
- [Inventory introduction](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.- html#hosts-in-multiple-groups)
- [Windows modules](https://docs.ansible.com/ansible/latest/collections/ansible/windows/)
- [Playbook variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#registering-variables)
- [Playbook conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)
- [Playbook roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
