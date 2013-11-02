Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:47598 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3KBAEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 20:04:30 -0400
Received: by mail-ob0-f181.google.com with SMTP id wp4so5139233obc.26
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 17:04:30 -0700 (PDT)
Received: from larrylap.lan (cpe-75-81-36-251.kc.res.rr.com. [75.81.36.251])
        by mx.google.com with ESMTPSA id d8sm20399768oeu.6.2013.11.01.17.04.29
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 01 Nov 2013 17:04:29 -0700 (PDT)
Message-ID: <5274418B.6040704@lwfinger.net> (sfid-20131102_010446_076546_C9C7F3FA)
Date: Fri, 01 Nov 2013 19:04:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Interaction with new naming scheme for wireless devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I allow the system to name wifi devices using the new-style names like 
wlp0s2f1u, it is not possible to make a connection after unloading and reloading 
the driver. A reboot is necessary. If I modify 
/etc/udev/rules.d/70-persistent-net.rules to force the name to be wlanX, I can 
reconnect again after a unload/reload cycle.

Has anyone seen this behavior? Any suggestions?

Larry
