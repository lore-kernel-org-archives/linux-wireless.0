Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:60084 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753979AbcJOOpE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 10:45:04 -0400
To: Oliver Zemann <oliver.zemann@gmail.com>,
        linux-wireless@vger.kernel.org
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com> (sfid-20161015_164509_958310_D59C6E93)
Date: Sat, 15 Oct 2016 16:44:47 +0200
MIME-Version: 1.0
In-Reply-To: <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

could you please attach a full log? i see no driver loading here. this 
is just a small part of the kernel boot log, but no driver intialisation

Am 15.10.2016 um 16:00 schrieb Oliver Zemann:
> I have a clearfog pro (arm7) from marvel and bought a pcie wifi card. 
> Unfortunately, it does not work.
> I am not sure if this is a bug in the module or even in some pci-e 
> driver. Maybe someone could tell me that.
>
> dmesg:
>
> [ 5.348307] mvebu-pcie soc:pcie-controller: 
> /soc/pcie-controller/pcie@2,0: reset gpio is active low
> [ 5.358026] mvebu-pcie soc:pcie-controller: 
> /soc/pcie-controller/pcie@3,0: reset gpio is active low
> [ 5.421496] mvebu-pcie soc:pcie-controller: PCI host bridge to bus 
> 0000:00
> [ 5.428390] pci_bus 0000:00: root bus resource [io 0x1000-0xfffff]
> [ 5.434680] pci_bus 0000:00: root bus resource [mem 
> 0xf8000000-0xffdfffff]
> [ 5.441575] pci_bus 0000:00: root bus resource [bus 00-ff]
> [ 5.447083] pci 0000:00:02.0: [11ab:6828] type 01 class 0x060400
> [ 5.447198] pci 0000:00:03.0: [11ab:6828] type 01 class 0x060400
> [ 5.447295] PCI: bus0: Fast back to back transfers disabled
> [ 5.452887] pci 0000:00:02.0: bridge configuration invalid ([bus 
> 00-00]), reconfiguring
> [ 5.460911] pci 0000:00:03.0: bridge configuration invalid ([bus 
> 00-00]), reconfiguring
> [ 5.468986] PCI: bus1: Fast back to back transfers enabled
> [ 5.474491] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
> [ 5.474561] pci 0000:02:00.0: [168c:003c] type 00 class 0x028000
> [ 5.474593] pci 0000:02:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
> [ 5.474617] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
> [ 5.474667] pci 0000:02:00.0: supports D1 D2
> [ 5.511395] PCI: bus2: Fast back to back transfers enabled
> [ 5.516894] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
> [ 5.516905] pci 0000:02:00.0: of_irq_parse_pci() failed with rc=134
> [ 5.523207] pci 0000:00:03.0: BAR 14: assigned [mem 
> 0xf8000000-0xf82fffff]
> [ 5.530098] pci 0000:00:02.0: PCI bridge to [bus 01]
> [ 5.535082] pci 0000:02:00.0: BAR 0: assigned [mem 
> 0xf8000000-0xf81fffff 64bit]
> [ 5.542413] pci 0000:02:00.0: BAR 0: error updating (0xf8000004 != 
> 0xffffffff)
> [ 5.549652] pci 0000:02:00.0: BAR 0: error updating (high 0x000000 != 
> 0xffffffff)
> [ 5.557155] pci 0000:02:00.0: BAR 6: assigned [mem 
> 0xf8200000-0xf820ffff pref]
> [ 5.564396] pci 0000:00:03.0: PCI bridge to [bus 02]
> [ 5.569372] pci 0000:00:03.0: bridge window [mem 0xf8000000-0xf82fffff]
> [ 5.576256] pcieport 0000:00:03.0: enabling device (0140 -> 0142)
>
> lspci:
>
>
> [root@alarm alarm]# lspci
> 00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
> 00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
> 02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac 
> Wireless Network Adapter (rev ff)

>
> Thanks!
>
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
