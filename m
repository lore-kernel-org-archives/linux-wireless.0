Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2716 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab2FMPuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 11:50:07 -0400
Message-ID: <4FD8B6A0.4080101@broadcom.com> (sfid-20120613_175012_006427_00152A10)
Date: Wed, 13 Jun 2012 17:49:52 +0200
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
Subject: Re: [PATCH v2 3/9] brcm80211: smac: remove unused code for
 40MHz channels
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-4-git-send-email-seth.forshee@canonical.com>
 <20120613153703.GE3490@thinkpad-t410>
In-Reply-To: <20120613153703.GE3490@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 05:37 PM, Seth Forshee wrote:
> On Tue, Jun 05, 2012 at 09:34:03AM -0500, Seth Forshee wrote:
>> This code has been kept around in anticipation of adding support for
>> 40MHz channels, but subsequent patches to better integrate with mac80211
>> regulatory support will render it completely broken. Therefore we should
>> go ahead and remove it.
>>
>> Keep these changes separate from other cleanup patches in order to make
>> it easier to resurrect 40MHz channel support at some point in the
>> future.
> 
> Arend, can I add your Reviewed-by tag for this one?

Sure. I did review that one as well today.

Gr. AvS


