Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:23180 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYI3JFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 05:05:12 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1126239tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 02:05:10 -0700 (PDT)
Message-ID: <e001a6370809300205i4dbca6acy2ab7334f3c2573c5@mail.gmail.com> (sfid-20080930_110524_229441_577F5A22)
Date: Tue, 30 Sep 2008 14:35:10 +0530
From: "Anadi Mishra" <reachanadi@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222721184.27930.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com>
	 <1221488871.10177.44.camel@localhost.localdomain>
	 <e001a6370809290106s57660209lf590579f11f67647@mail.gmail.com>
	 <1222721184.27930.38.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one........

http://dev.laptop.org/pub/firmware/libertas/usb8388-5.110.22.p6.bin



On Tue, Sep 30, 2008 at 2:16 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-09-29 at 13:36 +0530, Anadi Mishra wrote:
>> Hi Dan,
>>             I am using 2.6.26.5 kernel. i got the firmware from olpc
>> site and now it is being loaded but still the card is not working.
>
> Which specific firmware version did you pull down?
>
> Dan
>
>>             I have set the debug level full (0x007FFFFF) and booted
>> the kernel with "option mem=2000M"
>>
>> mem=2000M because one guy suggested that was the reason for
>> nommu_map_single  see this
>>
>> https://lists.linux-foundation.org/pipermail/bugme-new/2006-May/014325.html
>>
>> dmesg says:
>>
>>
>> [ 230.175944] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.178184] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.179926] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.182049] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.183959] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.187946] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.189741] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.191910] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.194160] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.195909] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.195909] device: 'vcs4': device_add
>> [ 230.195909] PM: Adding info for No Bus:vcs4
>> [ 230.195909] device: 'vcsa4': device_add
>> [ 230.195909] device: 'vcs6': device_add
>> [ 230.195909] PM: Adding info for No Bus:vcs6
>> [ 230.195909] device: 'vcsa6': device_add
>> [ 230.195909] PM: Adding info for No Bus:vcsa6
>> [ 230.195909] PM: Adding info for No Bus:vcsa4
>> [ 230.196097] device: 'vcs3': device_add
>> [ 230.196097] PM: Adding info for No Bus:vcs3
>> [ 230.196097] device: 'vcsa3': device_add
>> [ 230.196097] PM: Adding info for No Bus:vcsa3
>> [ 230.199913] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.199913] device: 'vcs5': device_add
>> [ 230.199913] PM: Adding info for No Bus:vcs5
>> [ 230.199913] device: 'vcsa5': device_add
>> [ 230.199913] PM: Adding info for No Bus:vcsa5
>> [ 230.199913] device: 'vcs2': device_add
>> [ 230.199913] PM: Adding info for No Bus:vcs2
>> [ 230.199913] device: 'vcsa2': device_add
>> [ 230.199913] PM: Adding info for No Bus:vcsa2
>> [ 230.199913] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.201458] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.203712] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.207914] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.209518] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.211818] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.213940] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.215941] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.218369] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.220120] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.221722] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.223962] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.225988] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.228098] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.229472] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.230221] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.244101] bus: 'acpi': add driver battery
>> [ 230.255088] usb8xxx usb (INT): Waiting for confirmation; got 0 30000
>> [ 230.255096] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.316110] device class 'video_output': registering
>> [ 230.320301] bus: 'acpi': add driver video
>> [ 230.331825] bus: 'acpi': add driver container
>> [ 230.385336] bus: 'acpi': add driver smbus_hc
>> [ 230.399341] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
>> [ 230.427407] bus: 'acpi': add driver sbs
>> [ 230.431767] usb8xxx usb (INT): Download complete, no event. Assuming success
>> [ 230.431835] usb8xxx usbd (INT): 1-8:URB status is failed during fw load
>> [ 230.431865] usb8xxx leave: if_usb_prog_firmware(), ret 0
>> [ 230.431867] libertas enter: lbs_add_card()
>> [ 230.431874] libertas enter: lbs_init_adapter()
>> [ 230.431910] libertas enter: lbs_allocate_cmd_buffer()
>> [ 230.431921] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431923] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431924] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431926] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431927] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431929] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431930] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431932] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431933] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431935] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431936] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431938] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431939] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431941] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431942] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431944] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431945] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431947] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431948] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [ 230.431950] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [ 230.431951] libertas leave: lbs_allocate_cmd_buffer(), ret 0
>> [ 230.431954] libertas leave: lbs_init_adapter(), ret 0
>> [ 230.431955] libertas thread: Starting main thread...
>> [ 230.433291] libertas enter: lbs_thread()
>> [ 230.433291] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 0
>> [ 230.433291] libertas thread: sleeping, connect_status 1, ps_mode 0, ps_state 0
>> [ 230.435363] libertas leave: lbs_add_card(), priv ffff810037160700
>> [ 230.435363] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.435363] libertas enter: lbs_start_card()
>> [ 230.435363] libertas enter: lbs_setup_firmware()
>> [ 230.435363] libertas enter: lbs_update_hw_spec()
>> [ 230.435363] libertas enter: __lbs_cmd()
>> [ 230.435363] libertas enter: __lbs_cmd_async()
>> [ 230.435363] libertas enter: lbs_get_cmd_ctrl_node()
>> [ 230.435363] libertas leave: lbs_get_cmd_ctrl_node()
>> [ 230.435363] libertas host: PREP_CMD: command 0x0003
>> [ 230.435363] libertas enter: lbs_queue_cmd()
>> [ 230.435363] libertas host: QUEUE_CMD: inserted command 0x0003 into cmdpendingq
>> [ 230.435363] libertas leave: lbs_queue_cmd()
>> [ 230.435363] libertas leave: __lbs_cmd_async(), ret ffff810037800000
>> [ 230.433291] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [ 230.433291] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [ 230.433291] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [ 230.433291] libertas enter: lbs_execute_next_command()
>> [ 230.433291] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [ 230.433291] libertas enter: lbs_submit_command()
>> [ 230.433291] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [ 230.433291] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00 00 00 00 00
>> [ 230.433291] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00 00 00 00 00
>> [ 230.433291] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [ 230.433321] usb8xxx usbd: 1-8:*** type = 1
>> [ 230.433322] usb8xxx usbd: 1-8:size after = 46
>> [ 230.433328] libertas leave: lbs_submit_command()
>> [ 230.433329] libertas leave: lbs_execute_next_command()
>> [ 230.433331] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [ 230.433332] libertas thread: sleeping, connect_status 1, ps_mode 0, ps_state 0
>> [ 230.435363] libertas enter (INT): lbs_host_to_card_done()
>> [ 230.435363] libertas leave (INT): lbs_host_to_card_done()
>> [ 230.435363] usb8xxx enter (INT): if_usb_receive()
>> [ 230.435363] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type = 0x160000
>> [ 230.435363] usb8xxx usbd (INT): 1-8:Unknown command type 0x160000
>> [ 230.435363] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [ 230.435363] usb8xxx leave (INT): if_usb_receive()
>> [ 231.931409] warning: `avahi-daemon' uses 32-bit capabilities (legacy
>> support in use)
>> [ 232.125705] device class 'ppdev': registering
>> [ 232.125705] device: 'parport0': device_add
>> [ 232.125705] PM: Adding info for No Bus:parport0
>> [ 232.125705] ppdev: user-space parallel port driver
>> [ 234.098263] Bluetooth: Core ver 2.11
>> [ 234.098263] Registering platform device 'bluetooth'. Parent at platform
>> [ 234.098263] device: 'bluetooth': device_add
>> [ 234.098340] bus: 'platform': add device bluetooth
>> [ 234.098564] PM: Adding info for platform:bluetooth
>> [ 234.102265] bus: 'bluetooth': registered
>> [ 234.102265] device class 'bluetooth': registering
>> [ 234.102265] NET: Registered protocol family 31
>> [ 234.102265] Bluetooth: HCI device and connection manager initialized
>> [ 234.102265] Bluetooth: HCI socket layer initialized
>> [ 234.134169] Bluetooth: L2CAP ver 2.9
>> [ 234.134169] Bluetooth: L2CAP socket layer initialized
>> [ 234.218329] Bluetooth: RFCOMM socket layer initialized
>> [ 234.218699] Bluetooth: RFCOMM TTY layer initialized
>> [ 234.218707] Bluetooth: RFCOMM ver 1.8
>> [ 235.558219] libertas enter (INT): command_timer_fn()
>> [ 235.558228] libertas: Command 3 timed out
>> [ 235.558232] libertas leave (INT): command_timer_fn()
>> [ 235.558240] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [ 235.558243] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [ 235.558246] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [ 235.558249] libertas: requeueing command 3 due to timeout (#1)
>> [ 235.558253] libertas enter: lbs_execute_next_command()
>> [ 235.558257] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [ 235.558259] libertas enter: lbs_submit_command()
>> [ 235.558262] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>>
>> [  235.558265] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  235.558277] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  235.558288] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  235.558299] usb8xxx usbd: 1-8:*** type = 1
>> [  235.558302] usb8xxx usbd: 1-8:size after = 46
>> [  235.558312] libertas leave: lbs_submit_command()
>> [  235.558315] libertas leave: lbs_execute_next_command()
>> [  235.558318] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  235.558321] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  235.558318] libertas enter (INT): lbs_host_to_card_done()
>> [  235.558323] libertas leave (INT): lbs_host_to_card_done()
>> [  235.558941] usb8xxx enter (INT): if_usb_receive()
>> [  235.558945] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type = 0x160000
>> [  235.558949] usb8xxx usbd (INT): 1-8:Unknown command type 0x160000
>> [  235.558956] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  235.558962] usb8xxx leave (INT): if_usb_receive()
>> [  240.713216] libertas enter (INT): command_timer_fn()
>> [  240.713222] libertas: Command 3 timed out
>> [  240.713226] libertas leave (INT): command_timer_fn()
>> [  240.713232] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  240.713235] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  240.713238] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  240.713241] libertas: requeueing command 3 due to timeout (#2)
>> [  240.713245] libertas enter: lbs_execute_next_command()
>> [  240.713248] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  240.713251] libertas enter: lbs_submit_command()
>> [  240.713254] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  240.713256] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  240.713268] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  240.713279] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  240.713290] usb8xxx usbd: 1-8:*** type = 1
>> [  240.713293] usb8xxx usbd: 1-8:size after = 46
>> [  240.713298] libertas leave: lbs_submit_command()
>> [  240.713301] libertas leave: lbs_execute_next_command()
>> [  240.713303] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  240.713307] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  240.713216] libertas enter (INT): lbs_host_to_card_done()
>> [  240.713220] libertas leave (INT): lbs_host_to_card_done()
>> [  240.713841] usb8xxx enter (INT): if_usb_receive()
>> [  240.713845] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type =
>> 0xE200019E
>> [  240.713849] usb8xxx usbd (INT): 1-8:Unknown command type 0xE200019E
>> [  240.713855] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  240.713860] usb8xxx leave (INT): if_usb_receive()
>> [  245.785713] libertas enter (INT): command_timer_fn()
>> [  245.785718] libertas: Command 3 timed out
>> [  245.785722] libertas leave (INT): command_timer_fn()
>> [  245.785729] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  245.785732] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  245.785735] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  245.785738] libertas: requeueing command 3 due to timeout (#3)
>> [  245.785742] libertas enter: lbs_execute_next_command()
>> [  245.785745] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  245.785747] libertas enter: lbs_submit_command()
>> [  245.785750] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  245.785753] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  245.785764] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  245.785776] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  245.785786] usb8xxx usbd: 1-8:*** type = 1
>> [  245.785789] usb8xxx usbd: 1-8:size after = 46
>> [  245.785795] libertas leave: lbs_submit_command()
>> [  245.785797] libertas leave: lbs_execute_next_command()
>> [  245.785800] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  245.785803] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  245.789431] libertas enter (INT): lbs_host_to_card_done()
>> [  245.789436] libertas leave (INT): lbs_host_to_card_done()
>> [  245.790055] usb8xxx enter (INT): if_usb_receive()
>> [  245.790059] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type =
>> 0xE200019E
>> [  245.790063] usb8xxx usbd (INT): 1-8:Unknown command type 0xE200019E
>> [  245.790070] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  245.790075] usb8xxx leave (INT): if_usb_receive()
>> [  249.528456] device: 'vcs1': device_unregister
>> [  249.528456] PM: Removing info for No Bus:vcs1
>> [  249.528456] device: 'vcs1': device_create_release
>> [  249.528456] device: 'vcsa1': device_unregister
>> [  249.528456] PM: Removing info for No Bus:vcsa1
>> [  249.528456] device: 'vcsa1': device_create_release
>> [  250.883892] libertas enter (INT): command_timer_fn()
>> [  250.883900] libertas: Command 3 timed out
>> [  250.883904] libertas leave (INT): command_timer_fn()
>> [  250.883912] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  250.883915] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  250.883918] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  250.883921] libertas: requeueing command 3 due to timeout (#4)
>> [  250.883925] libertas enter: lbs_execute_next_command()
>> [  250.883928] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  250.883931] libertas enter: lbs_submit_command()
>> [  250.883934] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  250.883936] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  250.883948] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  250.883960] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  250.883971] usb8xxx usbd: 1-8:*** type = 1
>> [  250.883974] usb8xxx usbd: 1-8:size after = 46
>> [  250.883984] libertas leave: lbs_submit_command()
>> [  250.883986] libertas leave: lbs_execute_next_command()
>> [  250.883989] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  250.883993] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  250.883993] libertas enter (INT): lbs_host_to_card_done()
>> [  250.883998] libertas leave (INT): lbs_host_to_card_done()
>> [  250.884616] usb8xxx enter (INT): if_usb_receive()
>> [  250.884620] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type =
>> 0xE200019E
>> [  250.884624] usb8xxx usbd (INT): 1-8:Unknown command type 0xE200019E
>> [  250.884631] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  250.884709] usb8xxx leave (INT): if_usb_receive()
>> [  256.004383] libertas enter (INT): command_timer_fn()
>> [  256.004390] libertas: Command 3 timed out
>> [  256.004394] libertas leave (INT): command_timer_fn()
>> [  256.004400] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  256.004403] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  256.004406] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  256.004409] libertas: requeueing command 3 due to timeout (#5)
>> [  256.004412] libertas enter: lbs_execute_next_command()
>> [  256.004415] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  256.004418] libertas enter: lbs_submit_command()
>> [  256.004421] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  256.004424] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  256.004435] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  256.004447] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  256.004458] usb8xxx usbd: 1-8:*** type = 1
>> [  256.004460] usb8xxx usbd: 1-8:size after = 46
>> [  256.004466] libertas leave: lbs_submit_command()
>> [  256.004469] libertas leave: lbs_execute_next_command()
>> [  256.004472] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  256.004475] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  256.004578] libertas enter (INT): lbs_host_to_card_done()
>> [  256.004582] libertas leave (INT): lbs_host_to_card_done()
>> [  256.005203] usb8xxx enter (INT): if_usb_receive()
>> [  256.005207] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type =
>> 0xE200019E
>> [  256.005210] usb8xxx usbd (INT): 1-8:Unknown command type 0xE200019E
>> [  256.005217] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  256.005283] usb8xxx leave (INT): if_usb_receive()
>> [  261.183881] libertas enter (INT): command_timer_fn()
>> [  261.183888] libertas: Command 3 timed out
>> [  261.183892] libertas leave (INT): command_timer_fn()
>> [  261.183898] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  261.183901] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  261.183905] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  261.183908] libertas: requeueing command 3 due to timeout (#6)
>> [  261.183911] libertas enter: lbs_execute_next_command()
>> [  261.183914] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  261.183917] libertas enter: lbs_submit_command()
>> [  261.183920] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  261.183922] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  261.183934] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  261.183945] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  261.183956] usb8xxx usbd: 1-8:*** type = 1
>> [  261.183959] usb8xxx usbd: 1-8:size after = 46
>> [  261.183965] libertas leave: lbs_submit_command()
>> [  261.183967] libertas leave: lbs_execute_next_command()
>> [  261.183970] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  261.183974] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  261.183881] libertas enter (INT): lbs_host_to_card_done()
>> [
>>   261.183886] libertas leave (INT): lbs_host_to_card_done()
>> [  261.184506] usb8xxx enter (INT): if_usb_receive()
>> [  261.184510] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type =
>> 0xE200019E
>> [  261.184514] usb8xxx usbd (INT): 1-8:Unknown command type 0xE200019E
>> [  261.184520] nommu_map_single: overflow 7f0000000012+1578 of device
>> mask ffffffff
>> [  261.184587] usb8xxx leave (INT): if_usb_receive()
>> [  264.167845] usb8xxx enter (INT): if_usb_receive()
>> [  264.167845] usb8xxx leave (INT): if_usb_receive()
>> [  264.171882] usb 1-8: USB disconnect, address 3
>> [  266.280013] libertas enter (INT): command_timer_fn()
>> [  266.280020] libertas: Command 3 timed out
>> [  266.280024] libertas leave (INT): command_timer_fn()
>> [  266.280031] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 0
>> [  266.280034] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 0
>> [  266.280037] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 0
>> [  266.280040] libertas: requeueing command 3 due to timeout (#7)
>> [  266.280044] libertas enter: lbs_execute_next_command()
>> [  266.280047] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  266.280049] libertas enter: lbs_submit_command()
>> [  266.280052] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  266.280055] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  266.280067] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  266.280078] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  266.280089] usb8xxx usbd: 1-8:*** type = 1
>> [  266.280091] usb8xxx usbd: 1-8:size after = 46
>> [  266.280095] usb8xxx usbd: 1-8:usb_submit_urb failed: -19
>> [  266.280097] libertas: DNLD_CMD: hw_host_to_card failed: -1
>> [  266.280100] libertas leave: lbs_submit_command()
>> [  266.280102] libertas leave: lbs_execute_next_command()
>> [  266.280105] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  266.280109] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  267.280013] libertas enter (INT): command_timer_fn()
>> [  267.280020] libertas: Command 3 timed out
>> [  267.280024] libertas leave (INT): command_timer_fn()
>> [  267.280031] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 2
>> [  267.280034] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 2
>> [  267.280037] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 2
>> [  267.280040] libertas: requeueing command 3 due to timeout (#8)
>> [  267.280044] libertas enter: lbs_execute_next_command()
>> [  267.280047] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  267.280050] libertas enter: lbs_submit_command()
>> [  267.280053] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  267.280055] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  267.280067] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  267.280078] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  267.280089] usb8xxx usbd: 1-8:*** type = 1
>> [  267.280092] usb8xxx usbd: 1-8:size after = 46
>> [  267.280095] usb8xxx usbd: 1-8:usb_submit_urb failed: -19
>> [  267.280098] libertas: DNLD_CMD: hw_host_to_card failed: -1
>> [  267.280100] libertas leave: lbs_submit_command()
>> [  267.280103] libertas leave: lbs_execute_next_command()
>> [  267.280106] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  267.280109] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  268.280013] libertas enter (INT): command_timer_fn()
>> [  268.280018] libertas: Command 3 timed out
>> [  268.280022] libertas leave (INT): command_timer_fn()
>> [  268.280028] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 2
>> [  268.280032] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 2
>> [  268.280035] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 2
>> [  268.280038] libertas: requeueing command 3 due to timeout (#9)
>> [  268.280041] libertas enter: lbs_execute_next_command()
>> [  268.280044] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  268.280046] libertas enter: lbs_submit_command()
>> [  268.280049] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  268.280052] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  268.280063] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  268.280075] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  268.280086] usb8xxx usbd: 1-8:*** type = 1
>> [  268.280088] usb8xxx usbd: 1-8:size after = 46
>> [  268.280091] usb8xxx usbd: 1-8:usb_submit_urb failed: -19
>> [  268.280094] libertas: DNLD_CMD: hw_host_to_card failed: -1
>> [  268.280097] libertas leave: lbs_submit_command()
>> [  268.280099] libertas leave: lbs_execute_next_command()
>> [  268.280102] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  268.280105] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  269.280030] libertas enter (INT): command_timer_fn()
>> [  269.280035] libertas: Command 3 timed out
>> [  269.280039] libertas leave (INT): command_timer_fn()
>> [  269.280045] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 2
>> [  269.280048] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 2
>> [  269.280051] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 2
>> [  269.280055] libertas: requeueing command 3 due to timeout (#10)
>> [  269.280058] libertas enter: lbs_execute_next_command()
>> [  269.280060] libertas host: EXEC_NEXT_CMD: sending command 0x0003
>> [  269.280063] libertas enter: lbs_submit_command()
>> [  269.280066] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
>> [  269.280069] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00
>> 00 00 00 00
>> [  269.280080] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00
>> 00 00 00 00
>> [  269.280091] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [  269.280102] usb8xxx usbd: 1-8:*** type = 1
>> [  269.280105] usb8xxx usbd: 1-8:size after = 46
>> [  269.280108] usb8xxx usbd: 1-8:usb_submit_urb failed: -19
>> [  269.280110] libertas: DNLD_CMD: hw_host_to_card failed: -1
>> [  269.280113] libertas leave: lbs_submit_command()
>> [  269.280115] libertas leave: lbs_execute_next_command()
>> [  269.280118] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  269.280122] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  270.280043] libertas enter (INT): command_timer_fn()
>> [  270.280049] libertas: Command 3 timed out
>> [  270.280053] libertas leave (INT): command_timer_fn()
>> [  270.280059] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 2
>> [  270.280062] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 2
>> [  270.280065] libertas thread: 4: currenttxskb 0000000000000000, dnld_sent 2
>> [  270.280068] libertas: Excessive timeouts submitting command 3
>> [  270.280073] libertas thread: 1: currenttxskb 0000000000000000, dnld_sent 2
>> [  270.280077] libertas thread: sleeping, connect_status 1, ps_mode 0,
>> ps_state 0
>> [  270.280526] libertas: PREP_CMD: command 0x0003 failed: -110
>> [  270.280526] libertas enter: __lbs_cleanup_and_insert_cmd()
>> [  270.280526] libertas leave: __lbs_cleanup_and_insert_cmd()
>> [  270.280526] libertas leave: __lbs_cmd(), ret -110
>> [  270.280526] libertas leave: lbs_update_hw_spec()
>> [  270.280526] libertas leave: lbs_setup_firmware(), ret -1
>> [  270.280526] libertas leave: lbs_start_card(), ret -1
>> [  270.280526] libertas enter: lbs_remove_card()
>> [  270.280526] libertas enter: lbs_remove_rtap()
>> [  270.283507] libertas thread: 2: currenttxskb 0000000000000000, dnld_send 2
>> [  270.283507] libertas thread: 3: currenttxskb 0000000000000000, dnld_sent 2
>> [  270.283507] libertas thread: break from main thread
>> [  270.283507] libertas leave: lbs_thread()
>> [  270.280526] libertas enter: lbs_free_adapter()
>> [  270.280526] libertas enter: lbs_free_cmd_buffer()
>> [  270.280526] libertas leave: lbs_free_cmd_buffer()
>> [  270.280526] libertas leave: lbs_free_adapter()
>> [  270.280526] libertas leave: lbs_remove_card()
>> [  270.280526] usb8xxx enter: if_usb_reset_device()
>> [  270.280526] usb8xxx usbd: 1-8:usb_submit_urb failed: -19
>> [  270.492515] usb8xxx leave: if_usb_reset_device(), ret -22
>> [  270.492520] usb8xxx enter: if_usb_free()
>> [  270.492523] usb8xxx leave: if_usb_free()
>> [  270.492523] usb8xxx: probe of 1-8:1.0 failed with error -12
>> [  270.492523] device: 'usbdev1.3_ep02': device_unregister
>> [  270.492523] PM: Removing info for No Bus:usbdev1.3_ep02
>> [  270.492523] device: 'usbdev1.3_ep83': device_unregister
>> [  270.492523] PM: Removing info for No Bus:usbdev1.3_ep83
>> [  270.492523] PM: Removing info for usb:1-8:1.0
>> [  270.492523] bus: 'usb': remove device 1-8:1.0
>> [  270.492523] device: 'usbdev1.3_ep00': device_unregister
>> [  270.492523] PM: Removing info for No Bus:usbdev1.3_ep00
>> [  270.492523] PM: Removing info for usb:1-8
>> [  270.492523] bus: 'usb': remove device 1-8
>> [  270.620349] usbcore: registered new interface driver usb8xxx
>> [  270.620359] usb8xxx leave: if_usb_init_module(), ret 0
>> [  270.895607] device: 'vcs7': device_add
>> [  270.895634] PM: Adding info for No Bus:vcs7
>> [  270.895661] device: 'vcsa7': device_add
>> [  270.898299] PM: Adding info for No Bus:vcsa7
>> [  271.115725] device: 'vcs7': device_unregister
>> [  271.115725] PM: Removing info for No Bus:vcs7
>> [  271.115725] device: 'vcs7': device_create_release
>> [  271.115725] device: 'vcsa7': device_unregister
>> [  271.115725] PM: Removing info for No Bus:vcsa7
>> [  271.115725] device: 'vcsa7': device_create_release
>> [  271.359391] device: 'vcs7': device_add
>> [  271.363155] PM: Adding info for No Bus:vcs7
>> [  271.363184] device: 'vcsa7': device_add
>> [  271.364755] PM: Adding info for No Bus:vcsa7
>> [  271.543244] device: 'vcs1': device_add
>> [  271.543274] PM: Adding info for No Bus:vcs1
>> [  271.543303] device: 'vcsa1': device_add
>> [  271.543353] PM: Adding info for No Bus:vcsa1
>> [  289.887329] device: '0:19': device_add
>> [  289.888223] PM: Adding info for No Bus:0:19
>>
>> I would also like to know that in the following message
>>
>> [  240.713222] libertas: Command 3 timed out
>>
>> how do we know what is  Command 3 ??
>> Is there some list of commands? I couldnt find any.
>>
>>
>> Thanks a lot for the help.
>>
>>
>> On Mon, Sep 15, 2008 at 7:57 PM, Dan Williams <dcbw@redhat.com> wrote:
>> >
>> > On Mon, 2008-09-15 at 15:28 +0530, Anadi Mishra wrote:
>> > > Hi all,
>> > >         I am using Libertas USB8388 WLAN card with Ubuntu 8.04 but am
>> > > not able to get it working.
>> > >
>> > >         The error(dmesg) says "unable to load firmware" even if the
>> > > usb8388.bin file is there in the /lib/firmware.
>> > >
>> > >         dmesg also says "probe of 3-1:1.1 failed with error -12"
>> > >
>> > > Any help would be gr8.
>> >
>> > What exact kernel version are you using?
>> >
>> > Also, please remove and re-insert insert the libertas.ko module like so:
>> >
>> > /sbin/modprobe libertas libertas_debug=0x1a43a7
>> >
>> > then plug the adapter in and post the output from 'dmesg' in a reply to
>> > this message.  We need a bit more information to find out what might be
>> > going wrong.
>> >
>> > Also, where did you get the firmware from?  It might be the wrong
>> > firmware file format.  There are two formats, the first being the
>> > driver-loadable format, the second is meant for flashing directly to the
>> > EEPROM if the dongle has any.  The second format is not used by the
>> > driver because it does not have any verification method like blocks or
>> > embedded CRCs.
>> >
>> > Dan
>> >
>> >
>>
>>
>>
>> --
>> Thanks and Regards,
>> Anadi Mishra,
>> Mumbai,
>> 9987388960.
>
>



-- 
Thanks and Regards,
Anadi Mishra,
Mumbai,
9987388960.
