Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41602 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751089AbdFSHjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 03:39:06 -0400
Message-ID: <1497857939.2259.4.camel@sipsolutions.net> (sfid-20170619_093908_714014_DA2103B9)
Subject: Re: [PATCH v2 07/26] rfkill.txt: standardize document format
From: Johannes Berg <johannes@sipsolutions.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org
Date: Mon, 19 Jun 2017 09:38:59 +0200
In-Reply-To: <0cbf26da98f6f6124c440be11452d0df7b537ec7.1497713221.git.mchehab@s-opensource.com>
References: <1a82f2bf2de4b016964cb71ff92dc3a472044f40.1497713221.git.mchehab@s-opensource.com>
         <0cbf26da98f6f6124c440be11452d0df7b537ec7.1497713221.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-06-17 at 12:26 -0300, Mauro Carvalho Chehab wrote:
> Each text file under Documentation follows a different
> format. Some doesn't even have titles!
> 
> Change its representation to follow the adopted standard,
> using ReST markups for it to be parseable by Sphinx:
> 
> - mark titles;
> - comment contents index;
> - mark literal blocks;
> - adjust identation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Fine by me, I assume somebody else is going to merge this?

Acked-by: Johannes Berg <johannes@sipsolutions.net>
