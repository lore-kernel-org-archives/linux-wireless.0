Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4048 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2KUJo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 04:44:59 -0500
Message-ID: <50ACA28F.9010800@broadcom.com> (sfid-20121121_104506_175357_85FC674F)
Date: Wed, 21 Nov 2012 10:44:47 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Daniel Wagner" <wagi@monom.org>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded
 debug/trace support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org>
 <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org>
 <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org>
 <50AC07F2.8000400@monom.org>
In-Reply-To: <50AC07F2.8000400@monom.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2012 11:45 PM, Daniel Wagner wrote:
>>
>> I am currently not able to reproduce a complete loss of connectivity.
>
> I fear it is a heisenbug. After turning the tracing off I was able to
> reproduce it very easily.

That is too bad. I always wondered about the tracing overhead affecting 
reproducibility. So the trace that you uploaded was not showing the 
issue of connection loss you are having?

Gr. AvS

