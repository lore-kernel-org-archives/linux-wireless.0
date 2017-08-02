Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:35635 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbdHBJKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:10:13 -0400
Received: by mail-qt0-f172.google.com with SMTP id p3so23266337qtg.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 02:10:13 -0700 (PDT)
Message-ID: <598196F3.9070208@broadcom.com> (sfid-20170802_111017_019210_84A61EBE)
Date: Wed, 02 Aug 2017 11:10:11 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, Michael Skeffington <mike@astro.ai>
Subject: Re: [PATCH] mac80211: remove mic_fail_no_key label
References: <20170802090431.GB2790@redhat.com>
In-Reply-To: <20170802090431.GB2790@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/2/2017 11:04 AM, Stanislaw Gruszka wrote:
> For historic reasons we have separate cases for mic_fail and
> mic_fail_no_key. But with current code we can merge those cases,
> as we already have NULL key check since:
>
> commit a66b98db570a638afd909459e1e6bfa272344bd3
> Author: Arik Nemtsov <arik@wizery.com>
> Date:   Thu Jun 23 00:00:24 2011 +0300
>
>      mac80211: fix rx->key NULL dereference during mic failure

Maybe better to use:
... since commit a66b98db570a ("mac80211: fix rx->key NULL dereference 
during mic failure").

as it is the preferred method to reference git commits.

Regards,
Arend
