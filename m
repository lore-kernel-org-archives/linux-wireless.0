Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49271 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2ISMkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 08:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <1348053493-22955-1-git-send-email-jarl@softace.dk>
References: <1348053493-22955-1-git-send-email-jarl@softace.dk>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 19 Sep 2012 22:39:56 +1000
Message-ID: <CAGRGNgUGOPt2iRaL+HGxsK-uFjSfmQVW6S0TzWhSgdZv7AJqTw@mail.gmail.com> (sfid-20120919_144036_996565_A53349B7)
Subject: Re: [PATCH 1/2] Added information about which firmware file is being requested.
To: Jarl Friis <jarl@softace.dk>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jarl,

You should really mention which driver these are for in the subject line, say:

[PATCH] b43: Added information about which firmware file is being requested

On Wed, Sep 19, 2012 at 9:18 PM, Jarl Friis <jarl@softace.dk> wrote:
> This is informative information to provide about which actual firmware
> file is being used.

Also, this patch is so small and obvious that you could arguably get
away with something like:

Subject: [PATCH] b43: Log firmware filename

Log the name of the firmware file requested.


Or something along those lines.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
