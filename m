Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:42426 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCBXbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 18:31:53 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1677879yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 15:31:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090302230232.76770@gmx.net>
References: <20090302222948.76770@gmx.net>
	 <b6c5339f0903021444m1f139f63p374cf41194ac2b62@mail.gmail.com>
	 <20090302230232.76770@gmx.net>
Date: Mon, 2 Mar 2009 18:31:50 -0500
Message-ID: <b6c5339f0903021531g18e5b8f9lf8b352e182a4ce6d@mail.gmail.com> (sfid-20090303_003157_322143_CA77DF87)
Subject: Re: [PATCH] ath5k: Set TSF fix
From: Bob Copeland <me@bobcopeland.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 6:02 PM, Alina Friedrichsen <x-alina@gmx.net> wrote:
>
> I personally think with the "& 0xffffffff" it's cleaner, because it's type
> independent. And the compiler should optimize it out, if the type is really
> 32 bit wide.

Yes, the compiler will optimize it out, but it looks noisy to me.  It's
declared u64 one line above so it is clearly a no-op...  I guess it is a
personal taste thing.

> This is an old patch, I now use git for it.

Ok, thanks!  I only mentioned it because I wanted to see the parameters
and had to go back to the code.

-- 
Bob Copeland %% www.bobcopeland.com
