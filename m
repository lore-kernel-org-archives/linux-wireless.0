Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:36593 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760841AbXJLJQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 05:16:54 -0400
Received: by wa-out-1112.google.com with SMTP id v27so929265wah
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 02:16:53 -0700 (PDT)
Message-ID: <f6ca9fed0710120216r282bb4b6tbcb063685a993c95@mail.gmail.com> (sfid-20071012_101721_559096_5A7F4FAD)
Date: Fri, 12 Oct 2007 11:16:52 +0200
From: dragoran <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ipw3945-devel] [PATCH 2.6.23.RC9] wpa_supplicant didn't work w/ wpa_secured hidden AP
Cc: "Abhijeet Kolekar" <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010202422.GN5962@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1192040814.12399.4.camel@abhi-desktop>
	 <20071010202422.GN5962@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch seems not to work for me, I tested with 2.6.23-6.fc8 (where
the patch is included)... played with ap_scan ... disabled hw_scan but
I was unable to acciotate.
