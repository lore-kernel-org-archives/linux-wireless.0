Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2JVNdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:33:44 -0400
Message-ID: <1350912857.10166.11.camel@jlt4.sipsolutions.net> (sfid-20121022_153348_442042_704AC5DF)
Subject: Re: [PATCH v2] iw: add lowpri and flush scan operands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 22 Oct 2012 15:34:17 +0200
In-Reply-To: <1350501604-25253-1-git-send-email-bzhao@marvell.com>
References: <1350501604-25253-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-17 at 12:20 -0700, Bing Zhao wrote:
> From: Sam Leffler <sleffler@chromium.org>
> 
> Add lowpri (low priority) and flush operands to the scan cmd to
> request the equivalent flags be set in the scan request. Note
> these are applied regardless of the feature flags to support
> testing drivers that do not implement them.
> 
> Signed-off-by: Sam Leffler <sleffler@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> v2: give lowpri/flush flags before ssid (Johannes Berg)

Applied, thanks. I changed it to 

[lowpri,flush]

instead of

[lowpri|flush]

since they aren't exclusive like other things where we used the [|]
notation.

johannes

