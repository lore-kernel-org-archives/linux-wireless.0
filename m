Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64257 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1LZUgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 15:36:48 -0500
Received: by eekc4 with SMTP id c4so11252175eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 12:36:46 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] mac80211: use RCU read locks for sta_info_get
Date: Mon, 26 Dec 2011 21:36:41 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>
References: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com> <201112261151.05309.chunkeey@googlemail.com> <4EF87199.2050207@qca.qualcomm.com>
In-Reply-To: <4EF87199.2050207@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201112262136.42040.chunkeey@googlemail.com> (sfid-20111226_213712_324850_94629569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 December 2011 14:07:37 Mohammed Shafi Shajakhan wrote:
> hi Christian,
> 
> On Monday 26 December 2011 04:21 PM, Christian Lamparter wrote:
> > On Monday 26 December 2011 07:59:38 Mohammed Shafi Shajakhan wrote:
> >> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> >>
> >> Cc: Paul Stewart<pstew@google.com>
> >> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> > huh, where did I sign that off? Anyway, You [or John?] can drop that line
> > and replace it with Cc: stable@kernel.org
> 
> i will send a proper v2 and this is being recently added by the commit 
> a85e1d55974646a442d95911e3f7d7a891ea9ac5, i will properly mention it 
> also. thank you
Oops, the rcu snafu was introduced recently and no need for Cc: stable.
Other than that: yep all seems to be there.
