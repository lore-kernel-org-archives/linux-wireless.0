Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52279 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaKEDTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:55 -0500
Received: by mail-lb0-f180.google.com with SMTP id u10so3754083lbd.39
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 19:19:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1414046257-22184-4-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com> <1414046257-22184-4-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 4 Nov 2014 19:19:32 -0800
Message-ID: <CAB=NE6X-8cGFT+KS4hBw0WSkmfMPhGGQFMzfusy5s0NSj=z0Sg@mail.gmail.com> (sfid-20141105_042007_687373_52BDAC8D)
Subject: Re: [PATCH 3/5] cfg80211: update missing fields in custom regulatory path
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
> From: Jonathan Doron <jond@wizery.com>
>
> Some channels fields were not being updated in the custom regulatory
> path. Update them according to the code in handle_channel().
>
> Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

 Luis
