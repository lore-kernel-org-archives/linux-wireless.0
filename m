Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1AEJ1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 04:27:09 -0500
Subject: Re: [RFC PATCH 13/17] zd1211rw: use stack for small cmd-buffers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <20110104234935.25309.7558.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
	 <20110104234935.25309.7558.stgit@fate.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 10:27:07 +0100
Message-ID: <1294219627.3590.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 01:49 +0200, Jussi Kivilinna wrote:
> Use stack for allocing small < 64 byte arrays.

I don't think this is valid -- DMA memory can't be from the stack.

johannes

