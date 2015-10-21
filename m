Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53971 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbbJUM3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:29:10 -0400
Message-ID: <1445430548.4558.36.camel@sipsolutions.net> (sfid-20151021_142914_315311_D98719D1)
Subject: Re: [PATCH] mesh: show mesh parameters when no args are given
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 21 Oct 2015 14:29:08 +0200
In-Reply-To: <1445429599-22148-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_141327_772348_BF722B5C)
References: <1445429599-22148-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151021_141327_772348_BF722B5C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-21 at 14:13 +0200, Ola Olsson wrote:
> The help text in "<get|set> mesh_param" says that
> available parameters will be shown if no args are given
> but that is not the case - fix that.
> 
> Also, add help text if a parameter is given but not found.
> 
Applied, thanks.

johannes
