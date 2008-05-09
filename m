Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:41280 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYEIEUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 00:20:08 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1106044fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 21:20:06 -0700 (PDT)
Message-ID: <d4a53e120805082120h33f7dfaes303a6c8fc69cab4e@mail.gmail.com> (sfid-20080509_061910_491741_9CACB150)
Date: Fri, 9 May 2008 08:20:06 +0400
From: "Oleg Lyashko" <tomcatuser.13@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: BUG: loading iwl4965 lockup CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Hardware: Asus M50SV, BIOS 208
OS: Debian lenny, kernel 2.6.24-1-686-bigmem

attempt to load iwl4965 crash laptop:

# modprobe iwl4965
BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
BUG: soft lockup - CPU#1 stuck for 11s! [modprobe:14501]
...

First compat-wireless-2.6 bug release date - 2008-05-02
(no problems with compat-wireless-2008-05-01.tar.bz2)

Regards,
Oleg Lyashko
