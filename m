Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:35863 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKEDIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 22:08:01 -0500
Received: by mail-la0-f53.google.com with SMTP id mc6so2075570lab.12
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 19:08:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1414046257-22184-2-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com> <1414046257-22184-2-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 4 Nov 2014 19:07:39 -0800
Message-ID: <CAB=NE6UG8XumXAtxoTpr5wCPzYvu+OuLrXhJOL6Cde0voX=5QA@mail.gmail.com> (sfid-20141105_040806_191475_F9888AC5)
Subject: Re: [PATCH 1/5] cfg80211: introduce regulatory flags controlling bw
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Allow setting bandwidth related regulatory flags. These flags are mapped
> to the corresponding channel flags in the specified range.
> Make sure the new flags are consulted when calculating the maximum
> bandwidth allowed by a regulatory-rule.
>
> Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
> channel.
>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

 Luis
