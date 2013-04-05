Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4666 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162957Ab3DEUum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 16:50:42 -0400
Message-ID: <515F3918.7090306@broadcom.com> (sfid-20130405_225046_679038_353628DF)
Date: Fri, 5 Apr 2013 22:50:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Greear" <greearb@candelatech.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V4] cfg80211: introduce critical protocol indication
 from user-space
References: <1365168312-14780-1-git-send-email-arend@broadcom.com>
 <515ED9BF.20203@candelatech.com> <515F23A4.3040906@broadcom.com>
 <515F2627.4050908@candelatech.com>
In-Reply-To: <515F2627.4050908@candelatech.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 09:29 PM, Ben Greear wrote:
> Or just require that the driver not fail this operation ever and always
> set crit_proto_started to false.

I tend to go for this option.

Gr. AvS

