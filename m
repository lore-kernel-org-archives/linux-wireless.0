Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46147 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941893AbdEYFLj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 01:11:39 -0400
Date: Thu, 25 May 2017 15:11:35 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: drivers/staging/ks7010 hardware test
Message-ID: <20170525051135.GA18753@eros> (sfid-20170525_071144_337171_06F6AFE5)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Wolfram,

I began testing the card you sent today. I'm getting a firmware load
error like you mentioned.

I checked out code from when you originally merged into staging,
however I built the module in a 4.9 kernel.

To help me track down the issue could you please tell me what testing
you managed to do successfully in the past, and if you can,
approximately the date you were doing the tests or the git commit of
the code you tested.

Thanks. Oh, also could you please indicate your level of interest my
continued efforts. I don't want to send you copious emails if you
would rather me not.

For anyone on the lists reading this, the hardware is

Spectec SDW-823 microSD (SDIO) Wi-Fi card

The error code is -EILSEQ (Illegal byte sequence). It is returned by
sdio_memcpy_fromio(). I do not know what it signifies?

thanks,
Tobin.

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZJmd8AAoJEEC/nkwmnWYHZXkP/jnjwSabxF6U0u8vXEv27LZH
apdD2AWz4y682Ki7OERtaSZS0xz7K4v0EF7NnvrwowZ8tfGpM3gpwM30Nt10wh7m
9wLQs05tQjlTQdjI1pmcOTulSZH2c4/YjInoxIe0wxD7yGlxi8YLwQ+ZNzjPk6te
/kH2FBpfnRGxjcQXAv3P2mJgdTx/aZ7GdzmTK32N0iwIHdvj5qfwnzCy3kGxJaPY
1LawWcoaNjbQ+mfZM30ORH5Z7l2IMKBAbhbZTWMWdonfxk1ESOIjUJT0PEbQyBm/
jmN9jeo3ltubcUsXsNDMllHguR5YNNEH/pi1jN8dW7yqQQSQhgvK0vgEejdYK1Tp
UFu20Jy7VYHQJxM+ZR83F6hQOaGwmXQwaD/dq1flLrBS7zPSXWAm/n9cFOrAKkmu
CMBaH7I1rwEoXrRnw4xR8IJQAeWhtKafHn1GlJGEUTaAID0wQoicF/EuCjqxjd1e
945HAzBbIS2o90ceB9lRVLOycdkPHBpjBo/H4mKC4RLszLZL3pkEqPCYWGcN/88z
AnvJuftvD99CYGVbreiDHiE563UjxdMEZm0KDQyGncicvWtiOjZDAXQ2GKDYNmq2
DQXXoEtRbqOeLMU6kg4H9GK7p5NEnWS7YI9jZMYVjDcP8m1aNye7DjePDjWPZYXO
psgwAe/ZMMynqWgry/Q8
=S+2K
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
