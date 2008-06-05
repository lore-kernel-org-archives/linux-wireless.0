Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:3071 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbYFENze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:55:34 -0400
Received: by rv-out-0506.google.com with SMTP id l9so728107rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 06:55:32 -0700 (PDT)
Message-ID: <b6c5339f0806050655m92bd361sbc048230c4bb9286@mail.gmail.com> (sfid-20080605_155538_212595_C7E294B2)
Date: Thu, 5 Jun 2008 09:55:32 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH] mac80211: add helpers for common frame_control testing
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212633200.6340.52.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212633200.6340.52.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2008 at 10:33 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> +static inline int ieee80211_has_a4(struct ieee80211_hdr *hdr)
> +{
> +       __le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_TODS);
> +       return (hdr->frame_control & tmp) == tmp;
> +}

One should be FROMDS?

-- 
Bob Copeland %% www.bobcopeland.com
