Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1AZVdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:33:14 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1295156534-4178-3-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 22:33:14 +0100
Message-ID: <1296077594.3635.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 07:42 +0200, Arik Nemtsov wrote:
> If a sta starts transmitting immediately after authentication, sometimes
> the FW deauthenticates it. Fix this by marking the sta "in-connection"
> in FW before sending the autentication response.

Starts transmitting what? If it starts transmitting data frames, it's
supposed to be deauthenticated ... it mustn't do that before it has
associated?!

johannes

