Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:22533 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbYILVuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 17:50:09 -0400
Received: by yx-out-2324.google.com with SMTP id 8so402262yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 14:50:08 -0700 (PDT)
Message-ID: <69e28c910809121450o5aaa9fe0m5b5d405be809362b@mail.gmail.com> (sfid-20080912_235018_449344_B61EDA57)
Date: Fri, 12 Sep 2008 23:50:07 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: fix virtual interfaces vs. injection
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221252767.5576.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221172545.5956.7.camel@johannes.berg>
	 <1221173167.5956.16.camel@johannes.berg>
	 <1221231237.5576.2.camel@johannes.berg>
	 <1221252767.5576.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 10:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> +       /*
> +        * Packet injection may want to control the sequence
> +        * number

Does this mean that this patch will allow for injecting frames with
preset sequence numbers without requiring a (hostapd-breaking) patch?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
