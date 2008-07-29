Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:18666 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYG2QdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 12:33:20 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4785982ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 09:33:19 -0700 (PDT)
Subject: Re: [PATCH 4/6] libertastf: command helper functions for libertastf
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1217173925.2700.33.camel@localhost.localdomain>
References: <48763883.2d352c0a.1af5.2270@mx.google.com>
	 <1217173925.2700.33.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 18:33:09 +0200
Message-Id: <1217349189.6379.78.camel@localhost> (sfid-20080729_183323_290504_987B68E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-27 at 11:52 -0400, Dan Williams wrote:
> Other than that, looks good.  I know I and Woodhouse (and maybe Holger)

There was no mention to Holger in the licenses when I started this. 

About David and you, there is a Red Hat license comment on two files,
assoc.[ch] from which I took nothing, and cmd.h from where I took two
macros and two function definitions. 

I know modifications by the three of you extend beyond what was noted by
the license comments but I thought I shouldn't add you if you were not
there already. I wouldn't mind doing so though.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


