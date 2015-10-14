Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34538 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbbJNVE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 17:04:58 -0400
Message-ID: <1444856696.3054.19.camel@sipsolutions.net> (sfid-20151014_230505_839313_A8C43AAE)
Subject: Re: new regdb file format
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 Oct 2015 23:04:56 +0200
In-Reply-To: <1444856468.3054.17.camel@sipsolutions.net> (sfid-20151014_230117_120171_44B5232E)
References: <1444855924.3054.9.camel@sipsolutions.net>
	 (sfid-20151014_225211_436416_85634BE8) <1444856468.3054.17.camel@sipsolutions.net>
	 (sfid-20151014_230117_120171_44B5232E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-14 at 23:01 +0200, Johannes Berg wrote:
> 
> More documentation is here:
> https://wireless.wiki.kernel.org/en/developers/todo-list/regdb-file
> -format
> 

FWIW, the file currently ends up being 3676 bytes with a new field for
the CAC timeout already added (though without signature, of course,
since I'm assuming that to be external with firmware load signing or
whatever)

regulatory.bin is currently 4592 bytes.

johannes
