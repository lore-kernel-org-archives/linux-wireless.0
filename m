Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:54659 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3BNOQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 09:16:38 -0500
Received: by mail-we0-f180.google.com with SMTP id k14so1936634wer.39
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 06:16:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360847317-31387-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1360847317-31387-1-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Thu, 14 Feb 2013 15:16:37 +0100
Message-ID: <CAND6uNnodOk=m9w6z49-L8=7M0EHEXe8H21Kn+e3s+Au+_=WFA@mail.gmail.com> (sfid-20130214_151641_627979_02DBE486)
Subject: Re: [PATCH] mac80211: fix ieee80211_sta_tx_notify for nullfunc
From: =?ISO-8859-1?Q?Magnus_Cederl=F6f?= <mcider@gmail.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Function ieee80211_sta_reset_conn_monitor has been
> resetting probe_send_count too early and nullfunc
> check was never called after succesfull ack.

I can confirm that the patch fixes the power save problem I had.

Thanks,
Magnus
