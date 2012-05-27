Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3960 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab2E0MS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 08:18:27 -0400
Message-ID: <4FC21B87.6040907@broadcom.com> (sfid-20120527_141829_895406_FA1F90EE)
Date: Sun, 27 May 2012 14:18:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 5/8] brcm80211: smac: enable/disable radio on
 regulatory updates
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-6-git-send-email-seth.forshee@canonical.com>
 <4FC008BB.1020606@broadcom.com> <20120526171817.GD11759@ubuntu-mba>
In-Reply-To: <20120526171817.GD11759@ubuntu-mba>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2012 07:18 PM, Seth Forshee wrote:
>> I think we need to validate the channels against our phy as well. See
>> > brcms_c_channels_init().
> I disable channels not supported by the phy in brcms_c_regd_init(), so
> it's not necessary to check it again here.
> 

Great. Missed that.

Gr. AvS

