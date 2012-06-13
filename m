Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3093 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2FMO02 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 10:26:28 -0400
Message-ID: <4FD8A307.8060705@broadcom.com> (sfid-20120613_162631_924763_5472AEDC)
Date: Wed, 13 Jun 2012 16:26:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 6/9] brcm80211: smac: enable/disable radio on
 regulatory updates
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-7-git-send-email-seth.forshee@canonical.com>
 <4FD85D47.8070609@broadcom.com> <20120613134330.GA3490@thinkpad-t410>
In-Reply-To: <20120613134330.GA3490@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 03:43 PM, Seth Forshee wrote:
> On Wed, Jun 13, 2012 at 11:28:39AM +0200, Arend van Spriel wrote:
>> When we were having fun in staging GregKH indicated that use of likely()
>> should be justified with profiling data. Probably not really needed here.
> 
> Okay, I'll remove it. This isn't performance critical code anyhow.
> 

That was my (un)educated guess as well. Thanks.

Gr. AvS


