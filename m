Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:46531 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753967Ab3ARNzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 08:55:47 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 23505-03 for <linux-wireless@vger.kernel.org>;
 Fri, 18 Jan 2013 13:55:45 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Subject: RE: [patch v2] b43: N-PHY: fix gain in b43_nphy_get_gain_ctl_workaround_ent()
Date: Fri, 18 Jan 2013 13:53:43 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7118@saturn3.aculab.com> (sfid-20130118_145607_784679_5B78A3D0)
In-Reply-To: <20130118133658.GA31186@elgon.mountain>
References: <50F84AF3.5070901@bfs.de> <20130118133658.GA31186@elgon.mountain>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +		int gain_data[] = {0x0062, 0x0064, 0x006a, 0x106a, 0x106c,
> +				   0x1074, 0x107c, 0x207c};

static const int ...

	David



