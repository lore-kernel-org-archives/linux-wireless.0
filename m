Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:56895 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0BSNXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 08:23:23 -0500
Received: by yxe38 with SMTP id 38so45701yxe.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 05:23:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100219012802.12460.42239.stgit@mj.roinet.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
Date: Fri, 19 Feb 2010 08:23:22 -0500
Message-ID: <b6c5339f1002190523y4d7cb999y19b73128d259879e@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make some
	functions static
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 8:28 PM, Pavel Roskin <proski@gnu.org> wrote:
> Remove all unnecessary function declarations from ath5k.h.  Comment out
> unused functions.  Remove ath5k_hw_get_tsf32(), which is too trivial to
> be commented out.  Make functions static if suggested by sparse.  Make
> ath5k_pm_ops static.

Thanks, Pavel.

(whole series)
Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
