Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2950 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3IKWlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 18:41:44 -0400
Message-ID: <5230F19F.2070701@broadcom.com> (sfid-20130912_004147_691039_C5992A0A)
Date: Wed, 11 Sep 2013 15:41:35 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: mail@janno-kaiser.de
cc: linux-wireless@vger.kernel.org
Subject: Re: brcmfmac, BCM43241
References: <5230D40B.20704@janno-kaiser.de>
In-Reply-To: <5230D40B.20704@janno-kaiser.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jan-Oliver,

Could you please send us the full log? Also please share more details 
about the hardware platform you are using. We need to figure out how to 
get the nvram file.

Regards,
Franky

On 09/11/2013 01:35 PM, Jan-Oliver Kaiser wrote:
> Hi,
>
> I am trying to get a BCM43241 card running on a 3.11-amd64 kernel.
> [1] lists the device as supported but gives no instructions on how to
> install it. I managed to extract the firmware from the git binary patch
> contained in [2].
>
> I copied the firmware to /lib/firmware/brcm/brcmfmac-sdio.bin and copied
> the content of /dev/nvram to /lib/firmware/brcm/brcmfmac-sdio.txt.
>
> Previously, `dmesg` would list error that indicated missing files.
> Currently, the output is as follows:
>
> [12865.299503] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
> Drive strength init done for chip 4324 rev 5 pmurev 17
> [12866.393551] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> [12867.402386] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> [12867.409143] brcmfmac: brcmf_proto_cdc_query_dcmd: brcmf_proto_cdc_msg
> failed w/status -5
> [12867.409149] brcmfmac: brcmf_fil_cmd_data: Failed err=-5
> [12867.409153] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr
> failed, -5
> [12867.409157] brcmfmac: brcmf_bus_start: failed: -5
> [12867.409167] brcmfmac: brcmf_sdbrcm_probe: dongle is not responding
> [12868.416890] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
> clkctl 0x50
> [12869.426308] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
> clkctl 0x50
>
> I have not been able to find anything to help with debugging this.
>
> There was some discussion in response to [2] that I don't understand. Is
> there something wrong with the firmware itself?
>
> I would be very grateful for any help. I can provide all additional
> information if something is missing from this report. (I can also be
> reached via IRC, 'Eruquen' on freenode)
>
> Thanks in advance,
> Jan-Oliver
>
> [1] http://wireless.kernel.org/en/users/Drivers/brcm80211
> [2] http://www.spinics.net/lists/linux-wireless/msg107754.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


