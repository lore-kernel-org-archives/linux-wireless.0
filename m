Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:39138 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752482Ab0IGAzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 20:55:24 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-031856522
	for <linux-wireless@vger.kernel.org>; Tue,  7 Sep 2010 09:48:43 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Fabio Rossi <rossi.f@inwind.it>
Subject: Re: ath5k calibration error
Date: Tue, 7 Sep 2010 09:48:29 +0900
Cc: linux-wireless@vger.kernel.org
References: <201009070110.11495.rossi.f@inwind.it>
In-Reply-To: <201009070110.11495.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009070948.29066.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue September 7 2010 08:10:11 Fabio Rossi wrote:
> In the patch 9e04a7eb1fdf37bc8bc0d0f59e5fb737926f0152 there has been a
> change in the possible return values from ath5k_hw_rf511x_iq_calibrate().
> 
> Sometimes I get -1 (before that commit the return value was always 0)
> because i_coffd:0, q_coffd:0 and the following error message is produced:
> 
>   ath5k phy0: calibration of channel 8 failed
> 
> Of course I'm running on channel 8.
> 
> Is this condition normal or something is weird? I have the following card:
> 
>   3Com Corporation AR5212 802.11abg NIC (3CRDAG675) (rev 01)
> 
> Thanks,
> Fabio

hmm, i guess i was wrong to introduce the -1 return value here, since this is 
not really an error condition... 

sorry,
bruno
