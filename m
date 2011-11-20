Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab1KTE5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 23:57:22 -0500
Received: by iage36 with SMTP id e36so5636527iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 20:57:21 -0800 (PST)
Message-ID: <4EC888A9.3050505@lwfinger.net> (sfid-20111120_055728_481851_08FA3485)
Date: Sat, 19 Nov 2011 22:57:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Bob Copeland <me@bobcopeland.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	=?ISO-8859-1?Q?Steinar_L=F8klingholm?= <steinar@megawatt.no>
Subject: Problem with hardware crypto
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On openSUSE 12.1 with kernel 3.1, Steinar Løklingholm reports that he needs to 
use the "nohwcrypt=1" option when loading ath5k, otherwise the interface does 
not work.

His bug report is at https://bugzilla.novell.com/show_bug.cgi?id=731576.

Is this a known problem? If not, I would appreciate someone looking at this report.

Thanks,

Larry
