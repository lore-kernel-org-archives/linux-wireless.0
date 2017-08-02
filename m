Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbdHBJhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:37:06 -0400
Date: Wed, 2 Aug 2017 11:35:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Michael Skeffington <mike@astro.ai>
Subject: Re: [PATCH] mac80211: remove mic_fail_no_key label
Message-ID: <20170802093551.GA4777@redhat.com> (sfid-20170802_113710_163695_112CEE25)
References: <20170802090431.GB2790@redhat.com>
 <598196F3.9070208@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <598196F3.9070208@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 02, 2017 at 11:10:11AM +0200, Arend van Spriel wrote:
> On 8/2/2017 11:04 AM, Stanislaw Gruszka wrote:
> >For historic reasons we have separate cases for mic_fail and
> >mic_fail_no_key. But with current code we can merge those cases,
> >as we already have NULL key check since:
> >
> >commit a66b98db570a638afd909459e1e6bfa272344bd3
> >Author: Arik Nemtsov <arik@wizery.com>
> >Date:   Thu Jun 23 00:00:24 2011 +0300
> >
> >     mac80211: fix rx->key NULL dereference during mic failure
> 
> Maybe better to use:
> ... since commit a66b98db570a ("mac80211: fix rx->key NULL
> dereference during mic failure").
> 
> as it is the preferred method to reference git commits.

Is easier for me to just copy-paste commit in form the git log/show
command provides, so I use that form. Is there tool or git log/show
option to get commit log in the preferred form, so I do not have to
change it manually?

Thanks
Stanislaw
