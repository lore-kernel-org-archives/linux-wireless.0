Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:63471 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663AbbA3Ot0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 09:49:26 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so3028153obb.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 06:49:25 -0800 (PST)
Date: Fri, 30 Jan 2015 08:49:11 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Disable VHT80 where 40/80 MHz on 5 GHz
 is not allowed
Message-ID: <20150130144911.GB124346@ubuntu-hedt> (sfid-20150130_154955_850418_EA196729)
References: <1422013872-9732-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422013872-9732-1-git-send-email-jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 01:51:12PM +0200, Jouni Malinen wrote:
> VHT80 was incorrectly enabled for number of countries.
> 
> 40 and 80 MHz channels are not allowed on 5 GHz for these:
> - Armenia (AM)
> - Bahrain (BH)
> - Costa Rica (CR)
> - Ecuador (EC)
> - Guam (GU)
> - Indonesia (ID) (also remove 40 MHz from 2.4 GHz)
> - North Korea (KP)
> - Sri Lanka (LK)
> - El Salvador (SV)
> 
> 80 MHz channels are not allowed on 5 GHz for these:
> - Egypt (EG)
> - Russia (RU)
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Applied, thanks.
