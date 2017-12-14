Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbdLNOXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 09:23:34 -0500
Date: Thu, 14 Dec 2017 15:22:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4356 does not initalize after firmware update
Message-ID: <20171214142243.GB2737@redhat.com> (sfid-20171214_152337_836440_77A6407D)
References: <20171213161257.GB2811@redhat.com>
 <5A3240B9.90007@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
In-Reply-To: <5A3240B9.90007@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2017 at 10:13:29AM +0100, Arend van Spriel wrote:
> The cur_etheraddr is the first piece of info we try to get from the
> firmware. Could you build the driver with CONFIG_BRCMDBG and load
> the module with 'debug=0x181416'.

dmesg attached. 

Thanks
Stanislaw

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brcmfmac-dmesg.txt"

[ 2665.150833] usbcore: deregistering interface driver brcmfmac
[ 2685.122741] brcmfmac: brcmfmac_module_init No platform data available.
[ 2685.123368] usbcore: registered new interface driver brcmfmac
[ 2685.129239] brcmfmac: brcmf_pcie_register Enter
[ 2685.131783] brcmfmac: brcmf_pcie_probe Enter 14e4:43ec (1/3)
[ 2685.132186] brcmfmac: brcmf_pcie_get_resource Phys addr : reg space = ffffa0ff40af0000 base addr 0x000000f7c00000
[ 2685.132194] brcmfmac: brcmf_pcie_get_resource Phys addr : mem space = ffffa0ff41800000 base addr 0x000000f7800000 size 0x400000
[ 2685.132213] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4356, rev=2
[ 2685.133298] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:47 base 0x18000000 wrap 0x18100000
[ 2685.133306] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:48 base 0x18001000 wrap 0x18101000
[ 2685.133312] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x83e:6  base 0x18002000 wrap 0x18102000
[ 2685.133320] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x83c:11 base 0x18003000 wrap 0x18103000
[ 2685.133326] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x81a:22 base 0x18004000 wrap 0x18104000
[ 2685.133332] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x829:21 base 0x18005000 wrap 0x18105000
[ 2685.133337] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x83d:2  base 0x18006000 wrap 0x18106000
[ 2685.133343] brcmfmac: brcmf_chip_cores_check  [8 ] core 0x135:0  base 0x00000000 wrap 0x1810a000
[ 2685.133348] brcmfmac: brcmf_chip_cores_check  [9 ] core 0x240:0  base 0x00000000 wrap 0x00000000
[ 2685.133353] brcmfmac: brcmf_chip_set_passive Enter
[ 2685.236599] brcmfmac: brcmf_pcie_reset_device config offset 0x0004, value 0x100106
[ 2685.236610] brcmfmac: brcmf_pcie_reset_device config offset 0x004c, value 0x4008
[ 2685.236618] brcmfmac: brcmf_pcie_reset_device config offset 0x0058, value 0x886805
[ 2685.236625] brcmfmac: brcmf_pcie_reset_device config offset 0x005c, value 0xfee0300c
[ 2685.236632] brcmfmac: brcmf_pcie_reset_device config offset 0x0060, value 0x0000
[ 2685.236638] brcmfmac: brcmf_pcie_reset_device config offset 0x0064, value 0x4182
[ 2685.236645] brcmfmac: brcmf_pcie_reset_device config offset 0x00dc, value 0x10001
[ 2685.236652] brcmfmac: brcmf_pcie_reset_device config offset 0x0228, value 0x0222
[ 2685.236658] brcmfmac: brcmf_pcie_reset_device config offset 0x0248, value 0x0000
[ 2685.236665] brcmfmac: brcmf_pcie_reset_device config offset 0x04e0, value 0x0017
[ 2685.236672] brcmfmac: brcmf_pcie_reset_device config offset 0x04f4, value 0x0000
[ 2685.236679] brcmfmac: brcmf_chip_set_passive Enter
[ 2685.237106] brcmfmac: brcmf_chip_get_raminfo RAM: base=0x180000 size=786432 (0xc0000) sr=0 (0x0)
[ 2685.237137] brcmfmac: brcmf_chip_setup ccrev=47, pmurev=24, pmucaps=0x420e5f18
[ 2685.237141] brcmfmac: brcmf_get_module_param Enter, bus=2, chip=17238, rev=2
[ 2685.237148] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
[ 2685.248121] brcmfmac: brcmf_fw_get_firmwares_pcie enter: dev=0000:03:00.0
[ 2685.252332] brcmfmac: brcmf_fw_request_code_done enter: dev=0000:03:00.0
[ 2685.252606] brcmfmac: brcmf_fw_request_nvram_done enter: dev=0000:03:00.0
[ 2685.256784] brcmfmac: brcmf_pcie_download_fw_nvram Halt ARM.
[ 2685.256790] brcmfmac: brcmf_pcie_download_fw_nvram Download FW brcm/brcmfmac4356-pcie.bin
[ 2685.588821] brcmfmac: brcmf_pcie_download_fw_nvram No matching NVRAM file found brcm/brcmfmac4356-pcie.txt
[ 2685.588831] brcmfmac: brcmf_pcie_download_fw_nvram Bring ARM in running state
[ 2685.588834] brcmfmac: brcmf_chip_set_active Enter
[ 2685.589035] brcmfmac: brcmf_pcie_download_fw_nvram Wait for FW init
[ 2685.639593] brcmfmac: brcmf_pcie_download_fw_nvram Shared RAM addr: 0x001f1528
[ 2685.639603] brcmfmac: brcmf_pcie_init_share_ram_info PCIe protocol version 5
[ 2685.639620] brcmfmac: brcmf_pcie_init_share_ram_info max rx buf post 255, rx dataoffset 0
[ 2685.639633] brcmfmac: brcmf_pcie_bus_console_init Console: base 23debc, buf 23dab4, size 1024
[ 2685.639657] brcmfmac: brcmf_pcie_init_ringbuffers Using TCM indices
[ 2685.639712] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 40
[ 2685.639736] brcmfmac: brcmf_pcie_request_irq Enter
[ 2685.639822] brcmfmac 0000:03:00.0: irq 31 for MSI/MSI-X
[ 2685.640052] brcmfmac: brcmf_attach Enter
[ 2685.640202] brcmfmac: brcmf_proto_attach Enter
[ 2685.642347] brcmfmac: brcmf_pcie_ring_mb_write_wptr W w_ptr 255 (0), ring 1
[ 2685.642354] brcmfmac: brcmf_pcie_ring_mb_ring_bell RING !
[ 2685.642594] brcmfmac: brcmf_pcie_ring_mb_write_wptr W w_ptr 8 (0), ring 0
[ 2685.642599] brcmfmac: brcmf_pcie_ring_mb_ring_bell RING !
[ 2685.642790] brcmfmac: brcmf_pcie_ring_mb_write_wptr W w_ptr 16 (0), ring 0
[ 2685.642796] brcmfmac: brcmf_pcie_ring_mb_ring_bell RING !
[ 2685.642838] brcmfmac: brcmf_fweh_register event handler registered for PSM_WATCHDOG
[ 2685.642846] brcmfmac: brcmf_bus_started 
[ 2685.642851] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
[ 2685.642855] brcmfmac: brcmf_add_if allocate netdev interface
[ 2685.642876] brcmfmac: brcmf_add_if  ==== pid:1c, if:wlan%d (00:00:00:00:00:00) created ===
[ 2685.642881] brcmfmac: brcmf_bus_change_state 0 -> 1
[ 2685.642996] brcmfmac: brcmf_pcie_ring_mb_write_wptr W w_ptr 17 (0), ring 0
[ 2685.643001] brcmfmac: brcmf_pcie_ring_mb_ring_bell RING !
[ 2685.701557] brcmfmac: brcmf_pcie_quick_check_isr Enter
[ 2685.701602] brcmfmac: brcmf_pcie_isr_thread Enter 100
[ 2685.701613] brcmfmac: brcmf_pcie_handle_mb_data D2H_MB_DATA: 0x10000000
[ 2685.701634] brcmfmac: CONSOLE: 0d
[ 2685.701706] brcmfmac: CONSOLE: 000000.049 sp+ec 00184635
[ 2685.701778] brcmfmac: CONSOLE: 000000.049 sp+f4 00182ca7
[ 2685.701854] brcmfmac: CONSOLE: 000000.049 sp+100 000001df
[ 2685.701928] brcmfmac: CONSOLE: 000000.049 sp+140 0000823f
[ 2685.702003] brcmfmac: CONSOLE: 000000.049 sp+150 0018b8d9
[ 2687.642667] brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
[ 2687.650464] brcmfmac: brcmf_fil_cmd_data Failed: BCME_NOTDOWN (-5)
[ 2687.650469] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cur_etheraddr, len=6
[ 2687.650471] brcmutil: data
[ 2687.650475] 00000000: 00 00 00 00 00 00                                ......
[ 2687.650479] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
[ 2687.658056] brcmfmac: brcmf_bus_started: failed: -5
[ 2687.663054] brcmfmac: brcmf_pcie_attach_bus: dongle is not responding
[ 2687.669658] brcmfmac: brcmf_pcie_remove Enter
[ 2687.669664] brcmfmac: brcmf_detach Enter
[ 2687.672761] brcmfmac: brcmf_bus_change_state 1 -> 0
[ 2687.672767] brcmfmac: brcmf_proto_detach Enter
[ 2687.672770] brcmfmac: brcmf_proto_msgbuf_detach Enter
[ 2687.674601] brcmfmac: brcmf_fweh_unregister event handler cleared for PSM_WATCHDOG
[ 2687.826671] brcmfmac: brcmf_pcie_reset_device config offset 0x0004, value 0x100106
[ 2687.826681] brcmfmac: brcmf_pcie_reset_device config offset 0x004c, value 0x4008
[ 2687.826689] brcmfmac: brcmf_pcie_reset_device config offset 0x0058, value 0x886805
[ 2687.826696] brcmfmac: brcmf_pcie_reset_device config offset 0x005c, value 0xfee0300c
[ 2687.826702] brcmfmac: brcmf_pcie_reset_device config offset 0x0060, value 0x0000
[ 2687.826709] brcmfmac: brcmf_pcie_reset_device config offset 0x0064, value 0x4192
[ 2687.826716] brcmfmac: brcmf_pcie_reset_device config offset 0x00dc, value 0x10001
[ 2687.826722] brcmfmac: brcmf_pcie_reset_device config offset 0x0228, value 0x0222
[ 2687.826729] brcmfmac: brcmf_pcie_reset_device config offset 0x0248, value 0x0000
[ 2687.826735] brcmfmac: brcmf_pcie_reset_device config offset 0x04e0, value 0x0017
[ 2687.826742] brcmfmac: brcmf_pcie_reset_device config offset 0x04f4, value 0x0000

--SUOF0GtieIMvvwua--
