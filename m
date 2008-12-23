Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5561 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLWO6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 09:58:08 -0500
Message-ID: <20081223095811.lmog5le728wccowc-cebfxv@webmail.spamcop.net> (sfid-20081223_155811_691379_2FBE5315)
Date: Tue, 23 Dec 2008 09:58:11 -0500
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	<43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	<20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	<43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	<20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
	<20081223062219.GT10807@tesla>
In-Reply-To: <20081223062219.GT10807@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <lrodriguez@atheros.com>:

> rm -rf on your wireless-regdb git tree and then git checkout -f.   
> Then cp that regulatory.bin
> to the REG_BIN location and try to build that CRDA. Then try that CRDA.

I remember I tried "make" in wireless-regdb without having M2Crypto  
installed.  Then I installed M2Crypto and ran "make clean" followed by  
"make".  "make clean" removed the original regulatory.bin.

The "clean" target doesn't normally remove files under version  
control.  It only removes files that everybody can generate.  For  
files that are harder to create, there is "make distclean" and "make  
maintainer-clean".

-- 
Regards,
Pavel Roskin
