Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53354 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab2JDRnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 13:43:03 -0400
From: Sven Eckelmann <sven@narfation.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath_hw: Use common REG_WRITE parameter order
Date: Thu, 04 Oct 2012 19:42:59 +0200
Message-ID: <6280245.pW1SF1FHQv@bentobox> (sfid-20121004_194318_368614_ABC13789)
In-Reply-To: <CAB=NE6XrTVQuAqGqD2wjyjN6ynyfB+yHXqBcAhRgOn=njBpAuA@mail.gmail.com>
References: <1349366701-23154-1-git-send-email-sven@narfation.org> <CAB=NE6XrTVQuAqGqD2wjyjN6ynyfB+yHXqBcAhRgOn=njBpAuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3327671.PMkRRnuHg5"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3327671.PMkRRnuHg5
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 04 October 2012 10:29:59 Luis R. Rodriguez wrote:
> On Thu, Oct 4, 2012 at 9:05 AM, Sven Eckelmann <sven@narfation.org> wrote:
> > All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
> > "register" and "value". hw.c is the only file using the order "ah",
> > "value" and "register". This inconsistent definition can easily lead to
> > implementation errors.
> > 
> > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> 
> Good catch! But can you resend specifying in your commit log that this
> change is a no-op?

I really don't know what you want from me here.

> Also it may help the reader for you to git grep and
> show the other REG_WRITE() definitions on the other c files within the
> commit log.

Ehrm, ok.

Kind regards,
	Sven
--nextPart3327671.PMkRRnuHg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQbcqjAAoJEF2HCgfBJntGgRUQAJILcboPdNndZCVueFEDbvMa
6iKzKaTaFjqrlGEkvn55BXpXQSh1rHD9kZufJXEvzgkjDJrKmD2R+stL9Oljx2Ob
ZE/AVB5xXIXhscgl21dgD427D9w+1INnYb1f7/+bJPNNtGE9dV41TkFI8DyBdi5E
mz8n/cHB3zngw4qc3u5u8qkz+NR48+kkbein+RuRGVOPleFFiQVCq8glSUa8q0YQ
uCAleNpip6YRGFinGoS4nal6jjJAsCkoQERknJP7UXj/6+kv7+ymBkPbNW5qfRBJ
FrPm4WC3TpWaeSJuje/hl+TClmr9ZpZ8HoE42pRzrUL3WlhxLfLe4Sadm1O98O05
P47PpADTm8FrIZhL/o8xak38X2OUXr+brJopjcJjefqUBpg7MxH1D1tp1aHzHeiy
/enDbvD7kUWGKqDMx2gLY5tmQBEJJP+RGoaLtJpWDYa6RUukk5XgaGAyRf7H9/br
Uvcg/aIC8MeQwCkYInmiIrkRviv2Vov5SYCzkl3xznlkeRm8Ze5M5H9eL3QoINfw
lPtfkHrsYfERZIl0zIgGjukxbZn3wTnWaUKHRCVdvxC4VLrCQvyvM3PYZdb3EVtu
7/N1j+dVjiTk3+oEeT6nHGWdFFOrkaq97y4ssKFiTnKk5zLdjK9gH+OC+omHGFts
HtIKHbXIaYRMdR/BMBei
=Qmq8
-----END PGP SIGNATURE-----

--nextPart3327671.PMkRRnuHg5--

