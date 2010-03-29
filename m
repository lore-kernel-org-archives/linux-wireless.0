Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0C2M6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 08:58:10 -0400
Subject: Re: iw station del broken?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@siemens.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BB0A16A.7080400@siemens.com>
References: <4BB0A16A.7080400@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 14:58:07 +0200
Message-ID: <1269867487.4131.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 14:47 +0200, Marco Porsch wrote:
> Hi list,
> 
> is it just me or is 'iw dev <devname> station del <MAC address>' broken?

No ... we decided a while ago that station manipulation in mesh was too
hard to support and removed it.

What's the use case anyway?

johannes

