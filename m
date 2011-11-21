Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18413 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab1KUXfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 18:35:53 -0500
Subject: Re: Firmware errors and warnings with Centrino Advanced-N 6205
From: wwguy <wey-yi.w.guy@intel.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Linux Network Mailing List <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111122002838.392f7622@x220>
References: <20111120210012.405bd632@x220>
	 <1321889065.2258.5.camel@wwguy-ubuntu>	<20111121194824.12f4c276@x220>
	 <1321903999.2258.8.camel@wwguy-ubuntu>	<20111121222335.19493eed@x220>
	 <1321915724.1834.2.camel@wwguy-ubuntu>  <20111122002838.392f7622@x220>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 15:29:31 -0800
Message-ID: <1321918171.1834.7.camel@wwguy-ubuntu> (sfid-20111122_003558_429499_D6137429)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Base on the information you provide, I am prettyr sure you are using
pure-40MHz. 

Is there any chance you have the access to the AP and check on it
configuration? is it "pure-40MHz above", could you either change it to
"20/40 MHz mixed mode", or change it to "pure-40MHz below" and see if
the problem is exist?

Thanks
Wey


On Mon, 2011-11-21 at 15:28 -0800, Udo Steinberg wrote:
> On Mon, 21 Nov 2011 14:48:44 -0800 wwguy (W) wrote:
> 
> W> btw, are you using pure 40MHz mode on your AP?
> 
> Hi Wey,
> 
> I am not sure, but I believe it's running some mix of 802.11 b/g/n.
> 
> The Linux that runs on the Fritz!Box says:
> 
> ath0      IEEE 802.11ng  ESSID:"XXX"  Nickname:""
>           Mode:Master  Frequency:2.412 GHz  Access Point: 00:24:FE:41:8D:0E   
>           Bit Rate:0 kb/s   Tx-Power:19 dBm   Sensitivity=0/3  
>           Retry:off   RTS thr:off   Fragment thr:off
>           Encryption key:XXXX-XXXX-XXXX-XXXX-XXXX-XXX-XXXX-EBCB [2]   Security mode:open
>           Power Management:off
>           Link Quality=49/94  Signal level=-60 dBm  Noise level=-109 dBm
>           Rx invalid nwid:3  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> The web interface shows that the AP uses channels 1-7 and sends on channel 1.
> I've attached a screenshot. Yellow bars indicate other WLANs and grey bars
> are other interference.
> 
> Cheers,
> 
> 	- Udo


