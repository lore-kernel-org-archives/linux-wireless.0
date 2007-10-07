Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:50541 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbXJGKNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 06:13:30 -0400
Received: by py-out-1112.google.com with SMTP id u77so1819084pyb
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2007 03:13:29 -0700 (PDT)
Message-ID: <40f31dec0710070313k6514882bkf5676d06ced25c53@mail.gmail.com> (sfid-20071007_111332_567582_324F60C6)
Date: Sun, 7 Oct 2007 03:13:28 -0700
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 6/6] ath5k: Do not let the driver through for not yet supported radios
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071006012057.GF25022@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo>
	 <20071006011949.GD25022@pogo> <20071006012017.GE25022@pogo>
	 <20071006012057.GF25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NACK i have a better fix wich uses chip srev, i had commited it on
ath5k branch on madwifi svn...

what's going on ? noone read my chagnes n ath5k branch on madwifi svn
? i did this change some time ago (over a month) and it seems you
didn't even saw it...

http://madwifi.org/changeset/2703
http://madwifi.org/changeset/2704

what happened to my changes ? you told me you would commit them here...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
