Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:47756 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYHZSvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 14:51:07 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1817496wri.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 11:51:06 -0700 (PDT)
Message-ID: <43e72e890808261151u5e7075a3p8532b57b011d3a20@mail.gmail.com> (sfid-20080826_205113_054811_B6A0F740)
Date: Tue, 26 Aug 2008 11:51:05 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Compat-wireless - will start fresh on 2.6.27
Cc: compat-masters@lists.madwifi.org,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Jiri Benc" <jbenc@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to let you know I've decided to not work on back porting TX MQ
changes on compat-wireless. I just haven't found the time and don't
think its worth it. When 2.6.27 comes out though I will start fresh on
compat-wireless for newer kernels. I'll keep around the old tarball
and if someone wants to take over that work it would be welcomed but
just keep in mind you'll need to backport TX MQ :)

Moving forward I expect compat-wireless to only support the last 3
kernel releases. Unless of course we hit another major issue with back
porting like TX MQ changes. Anything prior to 3 kernel release I just
will ignore but feel free to send patches (you know who you are
distribution people).

So to be clear, compat-wireless will support soon only >= 2.6.27. For
older kernels you can rely on the latest updated tarball:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/08/compat-wireless-2008-08-06.tar.bz2

  Luis
