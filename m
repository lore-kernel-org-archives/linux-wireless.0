Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZHFH2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 03:28:11 -0400
Subject: Re: [PATCH] nl80211: fix attrtype and value for
 NL80211_ATTR_SUPPORTED_COMMANDS
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249523206.4069.146.camel@debian>
References: <1249464510-21539-1-git-send-email-yi.zhu@intel.com>
	 <1249486901.6902.6.camel@johannes.local> <1249523206.4069.146.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GJqeRm+zAL9DEhz/QZ+p"
Date: Thu, 06 Aug 2009 09:28:01 +0200
Message-Id: <1249543681.555.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GJqeRm+zAL9DEhz/QZ+p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 09:46 +0800, Zhu Yi wrote:

> I'm trying to find if a command (i.e. NL80211_CMD_CONNECT) is supported
> or not. I think I can use nla_find_nested() if the command is an
> attribute. But I can also do the find myself if it is an array like now.

Ok, that would have worked too, but I'm pretty sure I documented it the
way I also implemented it.

johannes

--=-GJqeRm+zAL9DEhz/QZ+p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeoX+AAoJEODzc/N7+Qma9M8QAKyTrWeSz02fa38rmqnFyG0N
kr75qyv4hg1jyIZ8Xv6fXBZJEqYxD4RTwQs+jmteOT65rYRLv6vhSu1jFU3woMxW
n8BD9MIha+A7w/yF6uGXIaD7J+2fAUrRw8fQZom2S59cGMSNubBETmYCdEVEl0nr
saiOveVlm7B0lYvT+WPuZgAy4DsltKf0b7y4Y4LqkPYqWuwmFizm97sWB4B0+LTS
viwl5zDcweQdoLKyK6YTsb3TGZHFejzslLYeWOpwIKt5leX1vUd1hMgrbJMtzHZF
xjqqjYLMqNFijXzvDGbXztzlU/hy8ih10ZwoKQytMvWRPZEwoqZxKidNZlp2M4mD
di1wTioIFH5/6mqDK9s2SrBbgOk8MTnV91eNQvB1m7iWBcvFSM4qLeNwH1U+scSD
Rx5vLMUitg0TxB0IDMqvDspSG4cEOz/ONGCLg1mFd2U9CtZc9OOClBFEj2KsXD9C
2mZOtcdDLgHzT1waUj9FJhnuMDgzhGdR7LFC8bI0s8yCLGLl3piZZmcvrWejQQyQ
hIq4YYJLn7Jdnugv00kME5s/BotFxPAnxhikE1IELXQd6yZrBwJMGTrLJCPwPA8N
6/DwnoWcfxKctH8Ozl41WUKYzjeKqMFRa4xCB26uJxk8LlIRpCy0I3zyrog7BhA5
YSHuI83C+PJFaIrIPG4m
=6Aba
-----END PGP SIGNATURE-----

--=-GJqeRm+zAL9DEhz/QZ+p--

