Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:17100 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZKQVvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 16:51:16 -0500
Received: by gv-out-0910.google.com with SMTP id r4so156957gve.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 13:51:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	 <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	 <1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org>
	 <43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com>
Date: Tue, 17 Nov 2009 16:51:21 -0500
Message-ID: <b6c5339f0911171351m6c7e4e13o8f4329a6f8fb6f8d@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 11:38 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>  * DFS
>  * Multi-BSS AP functionality
>  * Roaming
>  * ANI

Also antenna selection has been requested -- this is dead simple
if anyone wants to write appropriate hooks into the stack for it.
The code is already in the driver, it just needs some configuration
glue.

-- 
Bob Copeland %% www.bobcopeland.com
