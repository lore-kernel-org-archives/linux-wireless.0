Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:45343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0AVUwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 15:52:50 -0500
Received: by ey-out-2122.google.com with SMTP id d26so405994eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 12:52:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001220701n7de4f943t60a9eda2b7791608@mail.gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
	 <69e28c911001220701n7de4f943t60a9eda2b7791608@mail.gmail.com>
Date: Fri, 22 Jan 2010 21:47:03 +0100
Message-ID: <b170af451001221247j1b380703w4c09b5fdd601466b@mail.gmail.com>
Subject: Re: [PATCH 0/5] b43: more N-PHY stuff
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 stycznia 2010 16:01 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/1/22 Rafał Miłecki <zajec5@gmail.com>:
>> John, I hope to have patch submission fixed, please let me know if there
>> is anything wrong still.
>
> Nope, it is still base64-encoded.
>
> I personally use Thunderbird 2 for patch submission (had weird
> problems with Thunderbird 3 beta - not sure about the final version).

I start hating that :| I checked for headers and all messages seem to have same:


Return-path: <zajec5@gmail.com>
Received: from localhost.localdomain (c3-107.icpnet.pl [62.21.3.107]) by
 mx.google.com with ESMTPS id 16sm1347862ewy.14.2010.01.21.16.53.24
 (version=TLSv1/SSLv3 cipher=RC4-MD5); Thu, 21 Jan 2010 16:53:25 -0800 (PST)
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, "John W. Linville"
 <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: check band width
Date: Fri, 22 Jan 2010 01:53:12 +0100
Message-ID: <1264121596-9616-2-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: RafaĹ MiĹecki <zajec5@gmail.com>


=====


Return-path: <zajec5@gmail.com>
Received: from localhost.localdomain (c3-107.icpnet.pl [62.21.3.107]) by
 mx.google.com with ESMTPS id 16sm1347862ewy.14.2010.01.21.16.53.12
 (version=TLSv1/SSLv3 cipher=RC4-MD5); Thu, 21 Jan 2010 16:53:12 -0800 (PST)
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, "John W. Linville"
 <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <zajec5@gmail.com>
Subject: [PATCH 0/5] b43: more N-PHY stuff
Date: Fri, 22 Jan 2010 01:53:11 +0100
Message-ID: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

John, I hope to have patch submission fixed, please let me know if there
is anything wrong still.


=====


Return-path: <zajec5@gmail.com>
Received: from localhost.localdomain (c3-107.icpnet.pl [62.21.3.107]) by
 mx.google.com with ESMTPS id 16sm1347862ewy.14.2010.01.21.16.53.34
 (version=TLSv1/SSLv3 cipher=RC4-MD5); Thu, 21 Jan 2010 16:53:34 -0800 (PST)
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, "John W. Linville"
 <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: implement overriding RF control
Date: Fri, 22 Jan 2010 01:53:13 +0100
Message-ID: <1264121596-9616-3-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: RafaĹ MiĹecki <zajec5@gmail.com>


As you can see I've used git send-email for submission this time! I've
no idea what I did wrong that patch 1/5 was sent incorrectly. I just
generated patches with
git format-patch --cover-letter -o b43
, then modified 0000-...patch (ONLY this one) and finally sent all
patches from b43 directory.

-- 
Rafał
