Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:36995 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZBDTeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:34:44 -0500
Received: by ewy14 with SMTP id 14so3778454ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 11:34:42 -0800 (PST)
Message-ID: <4989EDCE.5070209@gmail.com> (sfid-20090204_203446_960736_C055A1F3)
Date: Wed, 04 Feb 2009 19:34:38 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/17] orinoco: reorganisation
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Kilroy wrote:
> This patch series reorganises the orinoco driver. The focus is on
> splitting up the monolithic orinoco.c to make future changes easier.

> Because of patch conflicts, I've included Andrey's checkpatch cleanup
> patch. However there is still a conflict with Harvey Harrison's
> "wireless: replace use of __constant_{endian}" patch.

I see my timing is perfect :)

Since wireless-testing now has both these patches, I'll rebase this
series and repost.


Dave.
