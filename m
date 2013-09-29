Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61972 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2HGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 03:06:23 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so4254670pdj.7
        for <linux-wireless@vger.kernel.org>; Sun, 29 Sep 2013 00:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378044951-13682-1-git-send-email-arik@wizery.com>
References: <1378044951-13682-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 29 Sep 2013 10:06:07 +0300
Message-ID: <CA+XVXfdy2VdnTa55YJMQHTc+bj-oBUuSb1rT0nKbLKK7BZrSjQ@mail.gmail.com> (sfid-20130929_090637_514985_0A78F222)
Subject: Re: [PATCH v2] mac80211: implement STA CSA for drivers using channel contexts
To: Johannes Berg <johannes.berg@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 1, 2013 at 5:15 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Limit the current implementation to a single channel context used by
> a single vif, thereby avoiding multi-vif/channel complexities.
>
> Reuse the main function from AP CSA code, but move a portion out in
> order to fit the STA scenario.
>
> Add a new mac80211 HW flag so we don't break devices that don't support
> channel switch with channel-contexts. The new behavior will be opt-in.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

Ping?

Arik
