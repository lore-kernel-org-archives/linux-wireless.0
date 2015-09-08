Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbbIHVEE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 17:04:04 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<55EC71DB.7060007@lwfinger.net>
	<87d1xufvio.fsf@kamboji.qca.qualcomm.com> <55EDAEC9.701@lwfinger.net>
Date: Tue, 08 Sep 2015 17:04:04 -0400
In-Reply-To: <55EDAEC9.701@lwfinger.net> (Larry Finger's message of "Mon, 7
	Sep 2015 10:35:37 -0500")
Message-ID: <wrfjr3m8aaij.fsf@redhat.com> (sfid-20150908_230417_844670_2C4F509E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 09/07/2015 04:06 AM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> Ok. Can't we start just rtl8xxxu having just devices NOT supported by
>> rtlwifi drivers? All other devices would be under
>> CONFIG_RTL8XXXU_UNTESTED until we think the support is ready and we can
>> make the switch by moving from untested to tested category. And at the
>> same time disable/remove those devices from rtlwifi.
>
> Yes, that will work as long as we make CONFIG_RTL8XXXU_UNTESTED be
> EXPERIMENTAL to keep the distros from enabling it. In addition, a
> separate GitHub repo for rtl8xxxu should be made available with
> conditional code added to enable builds for kernels 3.10 or
> later. Then users that complain about some problem with rtl8192cu can
> be directed to that driver.

If someone wants to maintain a backported version of the driver for
certain kernels, that is fine with me. It should probably be in the form
of an out-of tree build package, so maybe simply a tarball would
suffice?

Cheers,
Jes
