Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4812 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2KSUud (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:50:33 -0500
Message-ID: <50AA9B8F.6000905@broadcom.com> (sfid-20121119_215036_892005_CF443857)
Date: Mon, 19 Nov 2012 21:50:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 05/22] brcmsmac: Use IEEE 802.11 AC levels for
 pktq precedence levels
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-6-git-send-email-seth.forshee@canonical.com>
 <50AA7D7C.8020208@broadcom.com> <20121119191625.GA20301@thinkpad-t410>
In-Reply-To: <20121119191625.GA20301@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 08:16 PM, Seth Forshee wrote:
>> True. I believe the statement actually applies to any retry include
>> >non-AMPDU.
> I don't see that non-AMPDU frames are ever requeued after failed tx. Am
> I overlooking soemthing?

Ah, you are right. non-ampdu frame retries are handled in hardware.

Gr. AvS

