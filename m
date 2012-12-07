Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2691 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab2LGJ7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 04:59:31 -0500
Message-ID: <50C1BDF3.2040101@broadcom.com> (sfid-20121207_105937_441675_0C20D0F8)
Date: Fri, 7 Dec 2012 10:59:15 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 05/11] brcmfmac: error messages should not be
 suppressed
References: <1354717564-7183-6-git-send-email-arend@broadcom.com>
 <1354742910-8822-1-git-send-email-arend@broadcom.com>
 <1354775578.8320.26.camel@joe-AO722>
In-Reply-To: <1354775578.8320.26.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2012 07:32 AM, Joe Perches wrote:
> This brcmf_err macro should probably be in dhd.h,
> not in a debug header and not guarded by DEBUG at all.

Not really. dhd.h is only used in common part of the driver. dhd_dbg.h
is used in common and bus-specific part of the driver. It is arguable
whether brcmf_err() or logging in general is a debugging feature, but I
do not want to go there.

Gr. AvS

