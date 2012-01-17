Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AQHoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 02:44:24 -0500
Subject: Re: [PATCH v2] compat-wireless: build: Throw error if space in path
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <1326758892-32135-1-git-send-email-asmadeus@codewreck.org> (sfid-20120117_010904_758548_2C83D669)
References: <CAB=NE6WAhddiUuf4yOfNAgqMF7GxM--ksDwEmvwdJdFYSjLGzA@mail.gmail.com>
	 <1326758892-32135-1-git-send-email-asmadeus@codewreck.org>
	 (sfid-20120117_010904_758548_2C83D669)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 08:44:21 +0100
Message-ID: <1326786261.3342.0.camel@jlt3.sipsolutions.net> (sfid-20120117_084429_847965_AF31344A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 01:08 +0100, Dominique Martinet wrote:
> Because of make limitations, the build will fail if there are spaces in
> the path leading to the compat-wireless directory.
> I tried to make it work anyway for a while and, while it probably is
> possible, it would involve rewriting part of kbuild and well...
> This at least throws up nicely if there is a space in the path.

I think it also fails if there's a colon in the path -- does anyone know
what the "forbidden" characters would be?

johannes

