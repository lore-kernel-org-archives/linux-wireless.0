Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43708 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2CFRUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 12:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <1331028575.3447.5.camel@jlt3.sipsolutions.net>
References: <CDCF1538AB98AA4FBCA89C8D5750845F1A473A21@MALMO.technikum.fh-joanneum.local>
 <1331027728-18496-1-git-send-email-cavallar@lri.fr> <1331028575.3447.5.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 6 Mar 2012 09:20:13 -0800
Message-ID: <CAB=NE6WkEjuRFrT64z8+rHqtAB6JSztxkXStCphcj77oMbfzcg@mail.gmail.com> (sfid-20120306_182040_705908_E912814C)
Subject: Re: [PATCH] compat: Fix module_init return type from void to int.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	Maximilian.Gmeiner.sam04@fh-joanneum.at,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 6, 2012 at 2:09 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2012-03-06 at 10:55 +0100, Nicolas Cavallari wrote:
>> Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Applied and pushed, thanks!

  Luis
