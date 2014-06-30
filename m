Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42772 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaF3LEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 07:04:39 -0400
Received: by mail-oa0-f44.google.com with SMTP id i7so8660276oag.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 04:04:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53B141CB.7010000@broadcom.com>
References: <1404071205-12568-1-git-send-email-zajec5@gmail.com>
	<53B141CB.7010000@broadcom.com>
Date: Mon, 30 Jun 2014 13:04:38 +0200
Message-ID: <CACna6rzisWW9YGQpOz9-PVD5bFg5ApzVfNSLbWmVJOYXgssqkQ@mail.gmail.com> (sfid-20140630_130442_146145_424BF807)
Subject: Re: [PATCH] b43: treat LCNXN-PHY as extra N-PHY devices
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 June 2014 12:54, Arend van Spriel <arend@broadcom.com> wrote:
> On 29-06-14 21:46, Rafał Miłecki wrote:
>> LCNXN is simply a continuation of N, e.g. code handling LCNXN revs 0 and
>> 1 is mostly the same as for N-PHY revs 7+.
>
> Hi Rafał,
>
> LCNXN is actually a LCN phy with 2 streams (mimo).

Err, I don't think so. Could you take a closer look at this? I'm
pretty sure LCNXN is continuation of N.

Maybe you were thinking about LCN40? I don't know much about LCN40,
maybe it's a variation of LCN?
