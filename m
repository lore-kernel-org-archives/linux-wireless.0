Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54016 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFRVyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 17:54:37 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so1168383pab.4
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 14:54:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 14:54:16 -0700
Message-ID: <CAB=NE6WT60mZ4-c8y5hmqGXxfT6P6ojwJakF_ySkAau7urh6fw@mail.gmail.com> (sfid-20140618_235440_829311_BB58DFEF)
Subject: Re: [PATCH 1/5] cfg80211: introduce regulatory flags controlling bw
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Allow setting bandwidth related regulatory flags. These flags are mapped
> to the corresponding channel flags in the specified range.
> Make sure the new flags are consulted when calculating the maximum
> bandwidth allowed by a regulatory-rule.
>
> Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
> channel.
>
> Change-Id: Ic120a291ef7a56f2efa800e77e9689c6c421affa
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-on: https://gerrit.rds.intel.com/32263
> Tested-by: IWL Jenkins
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
