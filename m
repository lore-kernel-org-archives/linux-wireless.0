Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out22.sjc.mx.trendmicro.com ([216.99.131.79]:62845 "EHLO
	out22.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbbIILRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 07:17:55 -0400
Received: from out03.sjc.mx.trendmicro.com (unknown [216.99.131.7])
	by out22.sjc.mx.trendmicro.com (Postfix) with ESMTP id 68D7FB015B2
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2015 10:51:28 +0000 (UTC)
Received: from relay09.sjc.mx.trendmicro.com (unknown [10.30.239.24])
	by out03.sjc.mx.trendmicro.com (Postfix) with ESMTP id 9C77998042A
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2015 10:51:27 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay09.sjc.mx.trendmicro.com (Postfix) with ESMTP id 0B082980436
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2015 10:51:26 +0000 (UTC)
Received: from unknown (HELO [192.168.5.9]) (br1@[188.86.86.230])
          (envelope-sender <br1@thinktube.com>)
          by 111.68.225.247 (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 9 Sep 2015 10:51:26 -0000
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for
 rtl8188[cr]u/rtl8192cu/rtl8723au
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
 <87y4gjfw10.fsf@kamboji.qca.qualcomm.com> <55EC71DB.7060007@lwfinger.net>
 <wrfjvbbkaams.fsf@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
From: Bruno Randolf <br1@thinktube.com>
Message-ID: <55F00F29.2090608@thinktube.com> (sfid-20150909_131758_558936_D4A72006)
Date: Wed, 9 Sep 2015 11:51:21 +0100
MIME-Version: 1.0
In-Reply-To: <wrfjvbbkaams.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2015 10:01 PM, Jes Sorensen wrote:
> I do not fully agree on this. In my testing I found rtl8192cu rather
> unstable, to the point of not being usable. It would lock up for me
> after a short while. I have seen this happen with mulitple different
> adapters. I suspect this is the reason why drivers/staging/rtl8192u is
> still sitting in the kernel tree.

I second this. Problems with rtc8192cu have been mentioned on this list
before: http://www.spinics.net/lists/linux-wireless/msg138538.html
I recently saw similar problems in STA mode as well.

> My take is that the majority of users mostly care about station support
> and for them rtl8xxxu will be much preferred to rtl8192cu.

Right. Users who need AP or IBSS mode can usually be expected to be able
to change kernel configurations or blacklist modules.

Also we hope that rtl8xxxu will be extended in the future to support
IBSS and AP mode as well! :)

bruno

