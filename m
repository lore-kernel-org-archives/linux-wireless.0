Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21214 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbXKZGH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 01:07:56 -0500
Message-ID: <20071126010755.uudf679us0wwwkcw@webmail.spamcop.net> (sfid-20071126_060800_217625_25D49E05)
Date: Mon, 26 Nov 2007 01:07:55 -0500
From: Pavel Roskin <proski@gnu.org>
To: Matt Herzog <msh@blisses.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: git guide page
References: <20071126053943.GD6034@chicago.blisses.org>
In-Reply-To: <20071126053943.GD6034@chicago.blisses.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Matt Herzog <msh@blisses.org>:

> http://linuxwireless.org/en/developers/git-guide#Getthelatestupdates
>
> So. This page is not helpful at all :(
>
> Specifically, the below syntax fails utterly.
>
> cd /usr/src/wireless-2.6
> git-checkout --track -b everything origin/everything
> Usage: /usr/bin/git-checkout [-f] [-b <new_branch>] [-m] [<branch>]   
> [<paths>...]

When reporting about software errors, please specify the version of  
the software that produces the error.

I guess your version of git is too old and doesn't support --track.

-- 
Regards,
Pavel Roskin
