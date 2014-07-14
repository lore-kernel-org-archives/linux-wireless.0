Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.outflux.net ([198.145.64.163]:49287 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbaGNVip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:45 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Morris <james.l.morris@oracle.com>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] firmware validation
Date: Mon, 14 Jul 2014 14:38:10 -0700
Message-Id: <1405373897-31671-1-git-send-email-keescook@chromium.org> (sfid-20140714_234038_177965_85194057)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This creates a new LSM hook to validate the contents (and origin) of
component firmware being provided to the kernel from userspace via the
request_firmware() interface.

Additionally creates a test module and test cases for all of the existing
interfaces as well as the new "fd" interface.

-Kees

